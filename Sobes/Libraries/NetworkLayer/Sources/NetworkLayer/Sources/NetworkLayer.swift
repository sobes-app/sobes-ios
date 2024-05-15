import Foundation
import SwiftyKeychainKit

public enum ClientError: Error, Equatable {
    case jsonEncodeError
    case jsonDecodeError
    case responseError
    case noDataError
    case httpError(Int)
}

public struct EmptyRequest: Encodable {
}

public struct ErrorResponse: Decodable {
    var statusCode: Int
    var message: String
    var description: String
}


public final class NetworkLayer {

    let baseUrl = "http://158.160.152.141:8080"
//    let baseUrl = "http://localhost:8080"

    public init() { }

    public func makeRequest<T: Decodable, Body: Encodable>(
        method: String,
        urlPattern: String,
        body: Body,
        completion: @escaping (Result<T, ClientError>) -> Void
    ) {
        guard let url = URL(string: baseUrl + urlPattern) else {
            completion(.failure(.responseError))
            return
        }

        var request = URLRequest(url: url)
        prepareAuthorizationHeader(for: &request)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method
        if method != "GET", let encodedBody = try? JSONEncoder().encode(body) {
            request.httpBody = encodedBody
        } else if method != "GET" {
            completion(.failure(.jsonEncodeError))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.responseError))
                return
            }

            switch httpResponse.statusCode {
            case 200...299:
                if let data = data {
                    self.handleSuccess(data: data, completion: completion)
                } else {
                    completion(.failure(.noDataError))
                }
            case 401, 403:
                self.handleUnauthorized(method: method, urlPattern: urlPattern, body: body, completion: completion)
            default:
                completion(.failure(.httpError(httpResponse.statusCode)))
            }
        }
        .resume()
    }

    private var isRefreshingToken = false
    private let refreshLock = DispatchSemaphore(value: 1)
    private let keychain: Keychain = Keychain(service: "com.swifty.keychain")
    private let accessTokenKey = KeychainKey<String>(key: "accessToken")
    private let refreshTokenKey = KeychainKey<String>(key: "refreshToken")
    private let tokenType = KeychainKey<String>(key: "tokenType")

    private func prepareAuthorizationHeader(for request: inout URLRequest) {
        if let tokenType = try? keychain.get(tokenType),
           let accessToken = try? keychain.get(accessTokenKey) {
            request.setValue("\(tokenType) \(accessToken)", forHTTPHeaderField: "Authorization")
        }
    }

    private func handleSuccess<T: Decodable>(data: Data, completion: @escaping (Result<T, ClientError>) -> Void) {
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedResponse))
        } catch {
            print("JSON decoding error:", error)
            completion(.failure(.jsonDecodeError))
        }
    }

    private func handleUnauthorized<T: Decodable, Body: Encodable>(
        method: String, urlPattern: String, body: Body, completion: @escaping (Result<T, ClientError>) -> Void
    ) {
        refreshLock.wait()
        if isRefreshingToken {
            refreshLock.signal()
            makeRequest(method: method, urlPattern: urlPattern, body: body, completion: completion)
            return
        }

        isRefreshingToken = true
        refreshLock.signal()

        refreshAccessToken { [weak self] result in
            guard let self = self else { return }

            self.refreshLock.wait()
            self.isRefreshingToken = false
            self.refreshLock.signal()

            switch result {
            case .success:
                self.makeRequest(method: method, urlPattern: urlPattern, body: body, completion: completion)
            case .failure:
                completion(.failure(.responseError))
            }
        }
    }

    private func refreshAccessToken(completion: @escaping (Result<Void, ClientError>) -> Void) {
        guard let url = URL(string: baseUrl + "/auth/refreshtoken") else {
            completion(.failure(.responseError))
            return
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        if let refreshToken = try? self.keychain.get(refreshTokenKey),
           let encodedBody = try? JSONEncoder().encode(RefreshTokenRequest(refreshToken: refreshToken)) {
            request.httpBody = encodedBody
        } else {
            completion(.failure(.jsonEncodeError))
            return
        }

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let data = data,
                  let self = self else {
                completion(.failure(.responseError))
                return
            }

            do {
                let refreshResponse = try JSONDecoder().decode(RefreshAccessTokenResponse.self, from: data)
                try self.keychain.set(refreshResponse.accessToken, for: self.accessTokenKey)
                completion(.success(()))
            } catch {
                completion(.failure(.jsonDecodeError))
            }
        }.resume()
    }

}

public extension Notification.Name {
    static let unauthNetworkNotificationName: Notification.Name = .init("unauthNoticationName")
}
