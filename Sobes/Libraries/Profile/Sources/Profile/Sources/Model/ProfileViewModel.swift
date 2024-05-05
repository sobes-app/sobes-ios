import Foundation
import Types
import Providers
import NetworkLayer

@MainActor
public protocol ProfileViewModel: ObservableObject {
    var profile: Profile? { get }
    var professions: [Professions] { get set }
    var companies: [Companies] { get set }
    var level: Types.Levels { get set }
    var stepsCount: Double { get }
    var isLoading: Bool { get }
    var isError: Bool { get }

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
    @Published public var profile: Profile?
    @Published public var professions: [Professions] = []
    @Published public var companies: [Companies] = []
    @Published public var level: Types.Levels = .no
    @Published public var stepsCount: Double = 3

    public init(profileProvider: ProfileProvider) {
        self.profileProvider = profileProvider
    }
    
    @MainActor
    public func onViewAppear() async -> Bool {
        isError = false
        isLoading = true
        return await updateProfile()
    }

    public func changePassword(oldPassword: String, newPassword: String) async -> Bool {
        isLoading = true
        let success = await profileProvider.changePassword(oldPassword: oldPassword, newPassword: newPassword)
        isLoading = false
        return success
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
        success = await updateProfile()
        isLoading = false
        return success
    }

    public func updateProfile(level: String? = nil, professions: [String]? = nil, companies: [String]? = nil) async -> Bool {
        isLoading = true
        var success = await profileProvider.updateProfile(level: level, professions: professions, companies: companies)
        success = await updateProfile()
        isLoading = false
        return success
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

    private let profileProvider: ProfileProvider

}
