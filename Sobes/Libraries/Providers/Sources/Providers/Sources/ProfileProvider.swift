import Foundation
import Types
import NetworkLayer
import SwiftyKeychainKit

public protocol ProfileProvider {
    var profile: Profile? {get set}
    
    func getProfile() async -> Result<Profile?, CustomError>
    func getCurrentUser() -> Profile
    func getProfiles() -> [Types.Profile]

    func getUserProfessions() async -> Result<[Professions], CustomError>
    func getUserLevel() async -> Result<Levels, CustomError>

    func sendEmail(email: String) async -> Bool
    func verifyCode(email: String, code: String) async -> Bool
    func registerUser(email: String, name: String, password: String) async -> Bool
    func authUser(email: String, password: String) async -> Bool
    func createProfile(exp: String, comp: [String], prof: [String]) async -> Bool
    func changePassword(oldPassword: String, newPassword: String) async -> Bool
    func recoverAccount(email: String) async -> Bool
    func forgotPassword(email: String, password: String) async -> Bool
    func updateProfile(level: String?, professions: [String]?, companies: [String]?) async -> Bool
    func updateToken() async -> Bool
    func logout()
}

public final class ProfileProviderImpl: ProfileProvider {
    
    public var profile: Types.Profile?
    
    public init() { }

    public func getUserProfessions() async -> Result<[Professions], CustomError> {
        let req = await getProfile()
        switch req {
        case .success(let profile):
            return .success(profile?.professions ?? [])
        case .failure(let error):
            return .failure(error)
        }
    }

    public func getUserLevel() async -> Result<Levels, CustomError> {
        let req = await getProfile()
        switch req {
        case .success(let profile):
            return .success(profile?.level ?? .no)
        case .failure(let error):
            return .failure(error)
        }
    }

    public func sendEmail(email: String) async -> Bool {
        let authClient = AuthClient(token: try? self.keychain.get(accessTokenKey), tokenType: try? self.keychain.get(tokenType))
        let result = await authClient.sendEmail(email: email)
        switch result {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    public func verifyCode(email: String, code: String) async -> Bool {
        let authClient = AuthClient(token: try? self.keychain.get(accessTokenKey), tokenType: try? self.keychain.get(tokenType))
        let result = await authClient.verifyCode(email: email, code: code)
        switch result {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    public func registerUser(email: String, name: String, password: String) async -> Bool {
        let authClient = AuthClient(token: try? self.keychain.get(accessTokenKey), tokenType: try? self.keychain.get(tokenType))
        let result = await authClient.registerUser(email: email, password: password, username: name)
        switch result {
        case .success(let success):
            try? self.keychain.set(success.token, for: self.accessTokenKey)
            try? self.keychain.set(success.refreshToken, for: self.refreshTokenKey)
            try? self.keychain.set(success.type, for: self.tokenType)
            self.profile = Profile(signUpResponse: success)
            return true
        case .failure:
            return false
        }
    }
    
    public func authUser(email: String, password: String) async -> Bool {
        let authClient = AuthClient(token: try? self.keychain.get(accessTokenKey), tokenType: try? self.keychain.get(tokenType))
        let result = await authClient.authUser(email: email, password: password)
        switch result {
        case .success(let success):
            try? self.keychain.set(success.token, for: self.accessTokenKey)
            try? self.keychain.set(success.refreshToken, for: self.refreshTokenKey)
            try? self.keychain.set(success.type, for: self.tokenType)
            self.profile = Profile(signUpResponse: success)
            return true
        case .failure:
            return false
        }
    }
    
    public func getProfile() async -> Result<Profile?, CustomError> {
        return await requestProfile()
	}
    
    public func createProfile(exp: String, comp: [String], prof: [String]) async -> Bool {
        let profileClient = ProfileClient(token: try? self.keychain.get(accessTokenKey), tokenType: try? self.keychain.get(tokenType))
        let result = await profileClient.createProfile(exp: exp, prof: prof, comp: comp)
        switch result {
        case .success(let success):
            profile?.level = Levels(rawValue: success.level ?? "") ?? .no
            profile?.professions = Profile.setProfessions(array: Array(success.professions ?? []))
            profile?.companies = Profile.setCompanies(array: Array(success.companies ?? []))
            return true
        case .failure:
            return false
        }
    }
    
    public func changePassword(oldPassword: String, newPassword: String) async -> Bool {
        let profileClient = ProfileClient(token: try? self.keychain.get(accessTokenKey), tokenType: try? self.keychain.get(tokenType))
        let result = await profileClient.resetPassword(oldPassword: oldPassword, newPassword: newPassword)
        switch result {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    public func getCurrentUser() -> Profile {
        return profile ?? Profile()
    }
    
    public func logout() {
        try? keychain.remove(accessTokenKey)
        try? keychain.remove(refreshTokenKey)
        try? keychain.remove(tokenType)
        profile = nil
        clearUserDefaultsData()
    }
    
    public func recoverAccount(email: String) async -> Bool {
        let authClient = AuthClient(token: try? self.keychain.get(accessTokenKey), tokenType: try? self.keychain.get(tokenType))
        let result = await authClient.recoverAccountRequest(email: email)
        switch result {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    public func forgotPassword(email: String, password: String) async -> Bool {
        let authClient = AuthClient(token: try? self.keychain.get(accessTokenKey), tokenType: try? self.keychain.get(tokenType))
        let result = await authClient.updatePassword(email: email, password: password)
        switch result {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    public func updateProfile(level: String? = nil, professions: [String]? = nil, companies: [String]? = nil) async -> Bool {
        let profileClient = ProfileClient(token: try? self.keychain.get(accessTokenKey), tokenType: try? self.keychain.get(tokenType))
        let result = await profileClient.updateProfile(level: level, professions: professions, companies: companies)
        switch result {
        case .success(let success):
            profile?.level = Levels(rawValue: success.level ?? "") ?? .no
            profile?.professions = Profile.setProfessions(array: Array(success.professions ?? []))
            profile?.companies = Profile.setCompanies(array: Array(success.companies ?? []))
            return true
        case .failure:
            return false
        }
    }
    
    public func updateToken() async -> Bool {
        try? keychain.remove(accessTokenKey)
        let authClient = AuthClient(token: try? self.keychain.get(accessTokenKey), tokenType: try? self.keychain.get(tokenType))
        let refreshToken = (try? self.keychain.get(refreshTokenKey)) ?? ""
        
        let result = await authClient.refreshToken(refreshToken: refreshToken)
        switch result {
        case .success(let success):
            try? self.keychain.set(success.accessToken, for: self.accessTokenKey)
            return true
        case .failure:
            return false
        }
    }
    
    public func getProfiles() -> [Types.Profile] {
        return profiles
    }

    private func requestProfile() async -> Result<Profile?, CustomError> {
        let profileClient = ProfileClient(
            token: try? self.keychain.get(accessTokenKey),
            tokenType: try? self.keychain.get(tokenType)
        )
        let result = await profileClient.getProfile()
        switch result {
        case .success(let success):
            self.profile = Profile(profileResponse: success)
            return .success(profile)
        case .failure(let error):
            self.profile = nil
            switch error {
            case .jsonEncodeError, .jsonDecodeError, .responseError:
                return .failure(.error)
            case .noDataError:
                return .failure(.empty)
            case .unautharized:
                return .failure(.unauthorized)
            case .httpError(let code):
                if code == 404 {
                    return .failure(.empty)
                } else {
                    return .failure(.error)
                }
            }
        }
    }

    private func clearUserDefaultsData() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }

    private var profiles: [Types.Profile] = [
        Profile()
    ]

    private let keychain: Keychain = Keychain(service: "com.swifty.keychain")
    private let accessTokenKey = KeychainKey<String>(key: "accessToken")
    private let refreshTokenKey = KeychainKey<String>(key: "refreshToken")
    private let tokenType = KeychainKey<String>(key: "tokenType")

}
