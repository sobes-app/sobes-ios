import Foundation

public struct EmailRequest: Encodable {
    var email: String
}

public struct UpdatePasswordRequest: Encodable {
    var email: String
    var password: String
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

public struct RefreshAccessTokenResponse: Decodable {
    public var accessToken: String
}

public struct SignUpResponse: Decodable {
    public var id: Int
    public var email: String
    public var username: String
    public var token: String
    public var type: String
    public var refreshToken: String
    public var role: String
}

@available(macOS 10.15, iOS 13.0, *)
open class AuthClient {
    
    let netLayer: NetworkLayer
    
    public init() {
        self.netLayer = NetworkLayer()
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
    
    public func refreshToken(refreshToken: String) async -> Result<RefreshAccessTokenResponse, ClientError> {
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(method: "POST",
                                      urlPattern: "/auth/refreshtoken",
                                      body: RefreshTokenRequest(refreshToken: refreshToken)) { result in
                continuation.resume(returning: result)
                
            }
        }
    }
    
    public func recoverAccountRequest(email: String) async -> Result<[String: String], ClientError> {
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(method: "POST",
                                      urlPattern: "/auth/recovery/email",
                                      body: EmailRequest(email: email)) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    public func updatePassword(email: String, password: String) async -> Result<[String: String], ClientError> {
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(method: "POST",
                                      urlPattern: "/auth/recovery",
                                      body: UpdatePasswordRequest(email: email, password: password)) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    public func logout() async -> Result<[String: String], ClientError> {
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(method: "GET",
                                      urlPattern: "/user/logout",
                                      body: EmptyRequest()) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    public func sendFeedback(content: String) async -> Result<FeedbackResponse, ClientError> {
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(method: "POST",
                                      urlPattern: "/feedback",
                                      body: FeedbackRequest(content: content)) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
