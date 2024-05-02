import Foundation

public struct EmailRequest: Encodable {
    var email: String
}

public struct VerifyCodeRequest: Encodable {
    var email: String
    var code: String
}

public struct RegisterRequest: Encodable {
    var email: String
    var username: String
    var password: String
}

public struct AuthRequest: Encodable {
    var email: String
    var password: String
}

public struct RefreshTokenRequest: Encodable {
    var refreshToken: String
}

public struct SignUpResponse: Decodable {
    public var id: Int
    public var email: String
    public var username: String
    public var token: String
    public var type: String
    public var refreshToken: String
}

public final class AuthClient {
    let netLayer: NetworkLayer
    
    public init(token: String?) {
        self.netLayer = NetworkLayer(token: token)
    }
    
    public func sendEmail(email: String) async -> Result<[String: String], ClientError> {
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(method: "POST",
                                      urlPattern: "/auth/email",
                                      body: EmailRequest(email: email)) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    public func verifyCode(email: String, code: String) async -> Result<[String: String], ClientError> {
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(method: "POST",
                                      urlPattern: "/auth/verify",
                                      body: VerifyCodeRequest(email: email, code: code)) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    public func registerUser(email: String,password: String,username: String) async -> Result<SignUpResponse, ClientError> {
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(method: "POST",
                                      urlPattern: "/auth/signup",
                                      body: RegisterRequest(email: email, username: username, password: password)) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    public func authUser(email: String, password: String) async -> Result<SignUpResponse, ClientError> {
        await withCheckedContinuation { [weak self] continuation in
            self?.netLayer.makeRequest(method: "POST",
                                      urlPattern: "/auth/signin",
                                      body: AuthRequest(email: email, password: password)) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    public func refreshToken(refreshToken: String,
                             completion: @escaping (Result<SignUpResponse, ClientError>) -> Void) {
        self.netLayer.makeRequest(method: "POST",
                                  urlPattern: "/auth/refreshtoken",
                                  body: RefreshTokenRequest(refreshToken: refreshToken),
                                  completion: completion)
    }
    
    public func recoverAccountRequest(email: String,
                                      completion: @escaping (Result<SignUpResponse, ClientError>) -> Void) {
        self.netLayer.makeRequest(method: "POST",
                                  urlPattern: "/auth/recovery",
                                  body: EmailRequest(email: email),
                                  completion: completion)
    }
}
