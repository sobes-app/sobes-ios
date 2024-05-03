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
    public var username: String?
    public var level: String?
    public var professions: [String]?
    public var companies: [String]?
}

public struct CreateProfileRequest: Encodable {
    public var experience: String
    public var professions: [String]
    public var companies: [String]
}

public struct UpdateProfile: Encodable {
    var experience: String?
    var companies: [String]?
    var professions: [String]?
}

public struct ResetPasswordRequest: Encodable {
    var oldPassword: String
    var newPassword: String
}

public final class ProfileClient {
    let netLayer: NetworkLayer
    
    public init(token: String?) {
        self.netLayer = NetworkLayer(token: token)
    }
    
    public func getProfile() async -> Result<ProfileResponse, ClientError>{
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(method: "GET",
                                      urlPattern: "/user/profile",
                                      body: EmptyRequest()) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    public func createProfile(exp: String, prof: [String], comp: [String]) async -> Result<ProfileResponse, ClientError> {
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(method: "POST",
                                      urlPattern: "/user/profile",
                                      body: CreateProfileRequest(experience: exp, professions:prof, companies: comp)) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    public func resetPassword(oldPassword: String, newPassword: String) async -> Result<[String:String], ClientError> {
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(method: "POST",
                                      urlPattern: "/auth/reset",
                                      body: ResetPasswordRequest(oldPassword: oldPassword, newPassword: newPassword)) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    public func updateProfile(level: String? = nil,
                              professions: [String]? = nil,
                              companies: [String]? = nil) async -> Result<ProfileResponse, ClientError> {
        
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(method: "PUT",
                                      urlPattern: "/user/profile",
                                      body: UpdateProfile(experience: level, companies: companies, professions: professions)) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
