import Foundation
import Types
import Providers
import NetworkLayer

@MainActor
public protocol ProfileViewModel: ObservableObject {
    var professions: [Professions] {get set}
    var companies: [Companies] {get set}
    var level: Types.Levels {get set}
    var stepsCount: Double {get set}
    
    var isLoading: Bool {get set}
    var isError: Bool {get set}
    
    func getProfileName() -> String
    func getProfileLevel() -> String
    func getProfileProfessions() -> String
    func getProfileCompanies() -> String
    func changePassword(oldPassword: String, newPassword: String) async -> Bool
    func setProfileInfo() async -> Bool
    func updateProfile(level: String?, professions: [String]?, companies: [String]?) async -> Bool

    func onViewAppear() async -> Bool
    func onLogoutTap()

    func isInfoNotEmpty() -> Bool
}

@MainActor
public final class ProfileViewModelImpl: ProfileViewModel {
    
    @Published public var isLoading: Bool = false
    @Published public var isError: Bool = false
    
    @Published var profile: Profile?
    
    @Published public var professions: [Professions] = []
    @Published public var companies: [Companies] = []
    @Published public var level: Types.Levels = .no
    @Published public var stepsCount: Double = 3
    
    public init(profileProvider: ProfileProvider) {
        self.profileProvider = profileProvider
    }
    
    public func changePassword(oldPassword: String, newPassword: String) async -> Bool {
        isLoading = true
        let success = await profileProvider.changePassword(oldPassword: oldPassword, newPassword: newPassword)
        isLoading = false
        return success
    }
    
    public func getProfileName() -> String {
        return profile?.name ?? ""
    }
    
    public func getProfileLevel() -> String {
        return level.rawValue
    }
    
    public func getProfileProfessions() -> String {
        return professions.map { $0.rawValue }.joined(separator: ", ")
    }
    
    public func getProfileCompanies() -> String {
        return companies.map { $0.rawValue }.joined(separator: ", ")
    }
    
    public func onViewAppear() async -> Bool{
        var success = true
        if profile == nil {
            success = await setProfile()
        }
        return success
    }
    
    func setProfile() async -> Bool {
        isLoading = true
        isError = false
        defer { isLoading = false }
        
        let result = await profileProvider.getProfile()
        switch result {
        case .success(let success):
            profile = success
            companies = profile?.companies ?? []
            professions = profile?.professions ?? []
            level = profile?.level ?? .no
            return true
        case .failure(let failure):
            return await setError(failure: failure)
        }
    }
    
    public func onLogoutTap() {
        profileProvider.logout()
        profile = nil
    }
    
    public func isInfoNotEmpty() -> Bool {
        profile?.level.rawValue.isEmpty == false
    }
    
    public func setProfileInfo() async -> Bool {
        isLoading = true
        isError = false
        defer { isLoading = false }
        
        let com = Profile.stringArrayComp(of: companies)
        let pro = Profile.stringArrayProf(of: professions)
        let result = await profileProvider.createProfile(exp: level.rawValue, comp: com, prof: pro)
        
        switch result {
        case .success:
            let success = await setProfile()
            return success
        case .failure(let failure):
            return await setError(failure: failure)
        }
    }
    
    public func updateProfile(level: String? = nil, professions: [String]? = nil, companies: [String]? = nil) async -> Bool {
        isLoading = true
        isError = false
        defer { isLoading = false }
        
        let result = await profileProvider.updateProfile(level: level, professions: professions, companies: companies)
        switch result {
        case .success:
            let success = await setProfile()
            return success
        case .failure(let failure):
            return await setError(failure: failure)
        }
    }
    
    private func updateProfile() async -> Bool {
        let request = await profileProvider.getProfile()
        switch request {
        case .success(let profile):
            isLoading = false
            self.profile = profile
        case .failure(let error):
            isLoading = false
            isError = true
            if error == .unauthorized {
                return await profileProvider.updateToken()
            }
        }
        return true
    }
    
    func setError(failure: CustomError) async -> Bool {
        switch failure {
        case .error, .empty:
            isError = true
            return false
        case .unauthorized:
            let update = await profileProvider.updateToken()
            if update {
                if await setProfile() {
                    return true
                } else {
                    isError = true
                    return false
                }
            } else {
                isError = true
                return false
            }
        }
            
    }
    private let profileProvider: ProfileProvider

}
