import Foundation
import Types
import Providers

@MainActor
public protocol ProfileViewModel: ObservableObject {
    var professions: [Professions] {get set}
    var companies: [Companies] {get set}
    var level: Types.Levels {get set}
    var stepsCount: Double {get set}
    var isLoading: Bool {get set}
    
    func getProfileName() -> String
    func getProfileLevel() -> String
    func changePassword(oldPassword: String, newPassword: String) async -> Bool
    func setProfileInfo() async -> Bool
    func updateProfile(level: String?, professions: [String]?, companies: [String]?) async -> Bool
    
    func onViewAppear() async
    func onLogoutTap()
    func createStringProf() -> String
    func createStringComp() -> String
}

@MainActor
public final class ProfileViewModelImpl: ProfileViewModel {
    let profileProvider: ProfileProvider
    
    @Published public var isLoading: Bool = false
    
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
        return profile?.level.rawValue ?? ""
    }
    
    public func onViewAppear() async {
        if profile == nil {
            await setProfile()
        }
    }
    
    func setProfile() async {
        profile = await profileProvider.getProfile()
    }
    
    public func onLogoutTap() {
        profileProvider.logout()
        profile = nil
    }
    
    public func setProfileInfo() async -> Bool {
        isLoading = true
        let com = Profile.stringArrayComp(of: companies)
        let pro = Profile.stringArrayProf(of: professions)
        let success = await profileProvider.createProfile(exp: level.rawValue, comp: com, prof: pro)
        await setProfile()
        isLoading = false
        return success
    }
    
    
    public func updateProfile(level: String? = nil, professions: [String]? = nil, companies: [String]? = nil) async -> Bool {
        isLoading = true
        let success = await profileProvider.updateProfile(level: level, professions: professions, companies: companies)
        await setProfile()
        isLoading = false
        return success
    }
    
    public func createStringProf() -> String {
        var a: [String] = []
        for i in profile?.professions ?? [] {
            a.append(i.rawValue)
        }
        return a.joined(separator: ", ")
    }
    
    public func createStringComp() -> String {
        var a: [String] = []
        for i in profile?.companies ?? [] {
            a.append(i.rawValue)
        }
        return a.joined(separator: ", ")
    }
}
