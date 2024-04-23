import Foundation
import Types
import Providers

@MainActor
public protocol ProfileViewModel: ObservableObject {
    var professions: [Professions] {get set}
    var companies: [Companies] {get set}
    var level: Types.Levels {get set}
    var stepsCount: Double {get set}
    
    func onViewAppear()
    func getProfile() -> Types.Profile
    func onLogoutTap()
    func saveInfo()
    func saveNewName(newName: String)
    func createStringProf(array: [Professions]) -> String
    func createStringComp(array: [Companies]) -> String
}

@MainActor
public final class ProfileViewModelImpl: ProfileViewModel {
    let profileProvider: ProfileProvider
    
    @Published public var professions: [Professions] = []
    @Published public var companies: [Companies] = []
    @Published public var level: Types.Levels = .no
    
    @Published public var stepsCount: Double = 3
    
    private let onLogoutAction: () -> Void
    
    public init(onLogoutAction: @escaping () -> Void, profileProvider: ProfileProvider) {
        self.onLogoutAction = onLogoutAction
        self.profileProvider = profileProvider
    }
    
    public func getProfile() -> Types.Profile {
        profileProvider.getProfiles()[0]
    }
    
    public func onViewAppear() {
        professions.removeAll()
    }
    
    
    public func onLogoutTap() {
        onLogoutAction()
    }
    
    
    public func saveInfo() {
        profileProvider.updateProfileInfo(id: profileProvider.getCurrentUser().id, companies: companies, level: level, professions: professions)
    }
    
    public func saveNewName(newName: String) {
        profileProvider.setNewName(name: newName)
    }
    
    public func createStringProf(array: [Professions]) -> String {
        var a: [String] = []
        for i in array {
            a.append(i.rawValue)
        }
        return a.joined(separator: ", ")
    }
    
    public func createStringComp(array: [Companies]) -> String {
        var a: [String] = []
        for i in array {
            a.append(i.rawValue)
        }
        return a.joined(separator: ", ")
    }
}
