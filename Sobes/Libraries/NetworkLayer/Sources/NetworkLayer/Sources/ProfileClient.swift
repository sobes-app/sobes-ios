//
//  File.swift
//
//
//  Created by Алиса Вышегородцева on 29.04.2024.
//

import Foundation

public struct ProfileResponse: Decodable {
    public var id: Int
    public var email: String
    public var username: String
    public var level: String
    public var professions: [String]
    public var companies: [String]
}

public struct CreateProfileRequest: Encodable {
    public var experience: String
    public var professions: [String]
    public var companies: [String]
}

public struct ResetPasswordRequest: Encodable {
    var oldPassword: String
    var newPasswoed: String
}

public final class ProfileClient {
    let netLayer: NetworkLayer
    
    public init(token: String?) {
        self.netLayer = NetworkLayer(token: token)
    }
    
    public func getProfile(completion: @escaping (Result<ProfileResponse, ClientError>) -> Void) {
        self.netLayer.makeRequest(method: "GET",
                                  urlPattern: "/user/profile",
                                  body: EmptyRequest(),
                                  completion: completion)
    }
    
    public func createProfile() async -> Result<ProfileResponse, ClientError> {
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(method: "POST",
                                      urlPattern: "/user/profile",
                                      body: CreateProfileRequest(experience: "", professions: [], companies: [])) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    public func resetPassword(oldPassword: String, newPassword: String) async -> Result<SignUpResponse, ClientError> {
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(method: "POST",
                                      urlPattern: "/auth/reset",
                                      body: ResetPasswordRequest(oldPassword: oldPassword, newPasswoed: newPassword)) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
