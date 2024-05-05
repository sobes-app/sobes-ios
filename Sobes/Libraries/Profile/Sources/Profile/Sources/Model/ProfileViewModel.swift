import Foundation
import Types
import Providers
import NetworkLayer

@MainActor
public protocol ProfileViewModel: ObservableObject {
    var profile: Profile? { get }
    var professions: [Professions] {get set}
    var companies: [Companies] {get set}
    var level: Types.Levels {get set}
    var stepsCount: Double {get set}
    var isLoading: Bool {get set}

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
    @Published public var profile: Profile?
    @Published public var professions: [Professions] = []
    @Published public var companies: [Companies] = []
    @Published public var level: Types.Levels = .no
    @Published public var stepsCount: Double = 3

    public init(profileProvider: ProfileProvider) {
        self.profileProvider = profileProvider
    }
    
    @MainActor
    public func onViewAppear() async {
        self.profile = await profileProvider.getProfile()
    }

    public func changePassword(oldPassword: String, newPassword: String) async -> Bool {
        isLoading = true
        let success = await profileProvider.changePassword(oldPassword: oldPassword, newPassword: newPassword)
        isLoading = false
        return success
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
        let result = await profileProvider.getProfile()
        switch result {
        case .success(let success):
            profile = success
            isLoading = false
            return true
        case .failure(let failure):
            if failure == ClientError.unautharized {
                let update = await profileProvider.updateToken()
                if update {
                    if await setProfile() {
                        isLoading = false
                        return true
                    } else {
                        isLoading = false
                        return false
                    }
                }
            }
            isLoading = false
            return false
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
        let com = Profile.stringArrayComp(of: companies)
        let pro = Profile.stringArrayProf(of: professions)
        var success = await profileProvider.createProfile(exp: level.rawValue, comp: com, prof: pro)
        success = await setProfile()
        // let success = await profileProvider.createProfile(exp: level.rawValue, comp: com, prof: pro)
        // profile = await profileProvider.getProfile()
        isLoading = false
        return success
    }

    public func updateProfile(level: String? = nil, professions: [String]? = nil, companies: [String]? = nil) async -> Bool {
        isLoading = true
        var success = await profileProvider.updateProfile(level: level, professions: professions, companies: companies)
        success = await setProfile()
        // let success = await profileProvider.updateProfile(level: level, professions: professions, companies: companies)
        // profile = await profileProvider.getProfile()
        isLoading = false
        return success
    }

    private let profileProvider: ProfileProvider

}
