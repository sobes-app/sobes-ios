import Foundation
import Types
import NetworkLayer
import SwiftyKeychainKit

public protocol ProfileProvider {
    var profile: Profile? {get set}
    
    func getProfile(onFinish: @escaping ((Result<Profile, ClientError>) -> Void))
    func getCurrentUser() -> Profile
    func updateProfileInfo(id: Int, companies: [Companies], level: Levels, professions: [Professions])
    func setNewName(name: String)
    func getProfiles() -> [Types.Profile]
    
    func sendEmail(email: String) async -> Bool
    func verifyCode(code: String) async -> Bool
    func registerUser(name: String, password: String) async -> Bool
    func authUser(email: String, password: String) async -> Bool
    func createProfile() async -> Bool
    func changePassword(oldPassword: String, newPassword: String) async -> Bool
    func logout()
}

public final class ProfileProviderImpl: ProfileProvider {
    
    public var profile: Types.Profile?
    
    private let keychain: Keychain = Keychain(service: "com.swifty.keychain")
    private let accessTokenKey = KeychainKey<String>(key: "accessToken")
    private var email: String = ""
        
    public init() { }
    
    public func sendEmail(email: String) async -> Bool {
        let authClient = AuthClient(token: try? self.keychain.get(accessTokenKey))
        let result = await authClient.sendEmail(email: email)
        switch result {
        case .success:
            self.email = email
            return true
        case .failure:
            return false
        }
    }
    
    public func verifyCode(code: String) async -> Bool {
        let authClient = AuthClient(token: try? self.keychain.get(accessTokenKey))
        let result = await authClient.verifyCode(email: email, code: code)
        switch result {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    public func registerUser(name: String, password: String) async -> Bool {
        let authClient = AuthClient(token: try? self.keychain.get(accessTokenKey))
        let result = await authClient.registerUser(email: email, password: password, username: name)
        switch result {
        case .success(let success):
            try? self.keychain.set(success.token, for: self.accessTokenKey)
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
            self.profile = Profile(signUpResponse: success)
            return true
        case .failure:
            return false
        }
    }
    
    public func getProfile(onFinish: @escaping ((Result<Profile, ClientError>) -> Void)) {
        let profileClient = ProfileClient(token: try? self.keychain.get(accessTokenKey))
        profileClient.getProfile(completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let resp):
                    let p = Profile(profileResponse: resp)
                    self.profile = p
                    onFinish(.success(p))
                case .failure(let fail):
                    onFinish(.failure(fail))
                }
            }
        })
    }

    public func createProfile() async -> Bool {
        let profileClient = ProfileClient(token: try? self.keychain.get(accessTokenKey))
        let result = await profileClient.createProfile()
        switch result {
        case .success(let success):
            profile?.level = Levels(rawValue: success.level) ?? .no
            profile?.professions = Profile.setProfessions(array: success.professions)
            profile?.companies = Profile.setCompanies(array: success.companies)
            return true
        case .failure:
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
        case .failure:
            print("f")
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
        profile = nil
    }
    
    
    public func getProfiles() -> [Types.Profile] {
        return profiles
    }
    
    
    private var profiles: [Types.Profile] = [
        Profile(id: 500, name: "Алиса Вышегородцева", email: "alisavy2010@gmail.com" ,professions: [], companies: [], level: .no)
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
