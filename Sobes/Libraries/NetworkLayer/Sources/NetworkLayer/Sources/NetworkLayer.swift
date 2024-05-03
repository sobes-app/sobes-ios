//
//  NetworkLayer.swift
//
//
//  Created by Ринат Афиатуллов on 18.04.2023.
//

import Foundation

public enum ClientError: Error {
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
    let token: String?
    
    //TODO: путь до бека
    let baseUrl = "http://localhost:8082"
    public init(token: String?) {
        self.token = token
    }
    
    public func makeRequest<T: Decodable, Body: Encodable> (
        method: String,
        urlPattern: String,
        body: Body,
        completion: @escaping (Result<T, ClientError>) -> Void) {
            let url = URL(string: baseUrl + urlPattern)!
            var request = URLRequest(url: url)
            if let token = token {
                print(token)
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = method
            if method != "GET" {
                let encoder = JSONEncoder()
                encoder.keyEncodingStrategy = .convertToSnakeCase
                guard let httpBody = try? encoder.encode(body) else {
                    completion(.failure(.jsonEncodeError))
                    return
                }
                request.httpBody = httpBody
            }
            let session: URLSession = {
                let session = URLSession(configuration: .default)
                session.configuration.timeoutIntervalForRequest = 30.0
                return session
            }()
            
            let task = session.dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 401, 403:
                        NotificationCenter.default.post(name: .unauthNetworkNotificationName, object: nil)
                        return
                    case 400...599:
                        print(httpResponse.statusCode)
                        completion(.failure(.httpError(httpResponse.statusCode)))
                        return
                    default:
                        break
                    }
                }
                
                guard error == nil else {
                    completion(.failure(.responseError))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.noDataError))
                    return
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let resp = try decoder.decode(T.self, from: data)
                    completion(.success(resp))
                } catch {
                    print(error)
                    completion(.failure(.jsonDecodeError))
                }
            }
            task.resume()
        }
}

public extension Notification.Name {
    static let unauthNetworkNotificationName: Notification.Name = .init("unauthNoticationName")
}
