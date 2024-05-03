import Foundation
import Types
import NetworkLayer
import SwiftyKeychainKit

public protocol ProfileProvider {
    var profile: Profile? {get set}
    
    func getProfile() async -> Profile
    func getCurrentUser() -> Profile
    func updateProfileInfo(id: Int, companies: [Companies], level: Levels, professions: [Professions])
    func getProfiles() -> [Types.Profile]
    
    func sendEmail(email: String) async -> Bool
    func verifyCode(email: String, code: String) async -> Bool
    func registerUser(email: String, name: String, password: String) async -> Bool
    func authUser(email: String, password: String) async -> Bool
    func createProfile(exp: String, comp: [String], prof: [String]) async -> Bool
    func changePassword(oldPassword: String, newPassword: String) async -> Bool
    func recoverAccount(email: String) async -> Bool
    func forgotPassword(email: String, password: String) async -> Bool
    func updateProfile(level: String?, professions: [String]?, companies: [String]?) async -> Bool
    func logout()
}

public final class ProfileProviderImpl: ProfileProvider {
    
    public var profile: Types.Profile?
    
    private let keychain: Keychain = Keychain(service: "com.swifty.keychain")
    private let accessTokenKey = KeychainKey<String>(key: "accessToken")
    private let refreshTokenKey = KeychainKey<String>(key: "refreshToken")
        
    public init() { }
    
    public func sendEmail(email: String) async -> Bool {
        let authClient = AuthClient(token: try? self.keychain.get(accessTokenKey))
        let result = await authClient.sendEmail(email: email)
        switch result {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    public func verifyCode(email: String, code: String) async -> Bool {
        let authClient = AuthClient(token: try? self.keychain.get(accessTokenKey))
        let result = await authClient.verifyCode(email: email, code: code)
        switch result {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    public func registerUser(email: String, name: String, password: String) async -> Bool {
        let authClient = AuthClient(token: try? self.keychain.get(accessTokenKey))
        let result = await authClient.registerUser(email: email, password: password, username: name)
        switch result {
        case .success(let success):
            try? self.keychain.set(success.token, for: self.accessTokenKey)
            try? self.keychain.set(success.refreshToken, for: self.refreshTokenKey)
            self.profile = Profile(signUpResponse: success)
            return true
        case .failure:
            return false
        }
    }
    
    public func authUser(email: String, password: String) async -> Bool {
        let authClient = AuthClient(token: try? self.keychain.get(accessTokenKey))
        let result = await authClient.authUser(email: email, password: password)
        switch result {
        case .success(let success):
            try? self.keychain.set(success.token, for: self.accessTokenKey)
            try? self.keychain.set(success.refreshToken, for: self.refreshTokenKey)
            self.profile = Profile(signUpResponse: success)
            return true
        case .failure:
            return false
        }
    }
    
    public func getProfile() async -> Profile {
        let profileClient = ProfileClient(token: try? self.keychain.get(accessTokenKey))
        let result = await profileClient.getProfile()
        switch result {
        case .success(let success):
            let refresh = (try? self.keychain.get(refreshTokenKey)) ?? ""
            let profile = Profile(profileResponse: success, refreshToken: refresh)
            setProfile(profile: profile)
            return profile
        case .failure(let failure):
            print(failure)
            return Profile()
        }
    }
    
    func updateProfile(response: ProfileResponse) {
        self.profile?.level = Levels(rawValue: response.level ?? "") ?? .no
        self.profile?.companies = Profile.setCompanies(array: Array(response.companies ?? []))
        self.profile?.professions = Profile.setProfessions(array: Array(response.professions ?? []))
    }

    public func createProfile(exp: String, comp: [String], prof: [String]) async -> Bool {
        let profileClient = ProfileClient(token: try? self.keychain.get(accessTokenKey))
        let result = await profileClient.createProfile(exp: exp, prof: prof, comp: comp)
        switch result {
        case .success(let success):
            profile?.level = Levels(rawValue: success.level ?? "") ?? .no
            profile?.professions = Profile.setProfessions(array: Array(success.professions ?? []))
            profile?.companies = Profile.setCompanies(array: Array(success.companies ?? []))
            return true
        case .failure(let failure):
            print(failure)
            return false
        }
    }
    
    public func changePassword(oldPassword: String, newPassword: String) async -> Bool {
        let profileClient = ProfileClient(token: try? self.keychain.get(accessTokenKey))
        let result = await profileClient.resetPassword(oldPassword: oldPassword, newPassword: newPassword)
        switch result {
        case .success:
            print("suc")
            return true
        case .failure(let failure):
            print(failure)
            return false
        }
    }
    
    public func setProfile(profile: Profile) {
        self.profile = profile
    }
    
    public func getCurrentUser() -> Profile {
        return profile ?? Profile()
    }
    
    public func logout() {
        try? keychain.remove(accessTokenKey)
        try? keychain.remove(refreshTokenKey)
        profile = nil
    }
    
    public func recoverAccount(email: String) async -> Bool {
        let authClient = AuthClient(token: try? self.keychain.get(accessTokenKey))
        let result = await authClient.recoverAccountRequest(email: email)
        switch result {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    public func forgotPassword(email: String, password: String) async -> Bool {
        let authClient = AuthClient(token: try? self.keychain.get(accessTokenKey))
        let result = await authClient.updatePassword(email: email, password: password)
        switch result {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    public func updateProfile(level: String? = nil, professions: [String]? = nil, companies: [String]? = nil) async -> Bool {
        let profileClient = ProfileClient(token: try? self.keychain.get(accessTokenKey))
        let result = await profileClient.updateProfile(level: level, professions: professions, companies: companies)
        switch result {
        case .success(let success):
            profile?.level = Levels(rawValue: success.level ?? "") ?? .no
            profile?.professions = Profile.setProfessions(array: Array(success.professions ?? []))
            profile?.companies = Profile.setCompanies(array: Array(success.companies ?? []))
            return true
        case .failure(let failure):
            print(failure)
            return false
        }
    }
    
    
    public func getProfiles() -> [Types.Profile] {
        return profiles
    }
    
    
    private var profiles: [Types.Profile] = [
        Profile()
    ]
    
    public func updateProfileInfo(id: Int, companies: [Companies], level: Levels, professions: [Professions]) {
//        profiles[id].level = level
//        profiles[id].professions = professions
//        profiles[id].companies = companies
    }
    
    public func setNewName(name: String) {
//        for i in profiles.indices {
//            if profiles[i] == profile {
//                profiles[i].name = name
//            }
//        }
    }
}
