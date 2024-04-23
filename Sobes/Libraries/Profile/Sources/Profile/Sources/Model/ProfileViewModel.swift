import Foundation
import Types

@MainActor
public protocol ProfileViewModel: ObservableObject {
    var specs: [Professions] {get}
    var level: Types.Levels {get set}
    var stepsCount: Double {get set}
    var profile: Types.Profile {get}
    
    func onViewAppear()
    func updateSpecs(specs: [Professions])
    func setSpecLevel(spec: Professions, level: Int)
    func onLogoutTap()
    func saveInfo()
    func saveNewName(newName: String)
    func createStringProf(array: [Professions]) -> String
    func createStringComp(array: [Companies]) -> String
    func updateCompanies(comps: [Companies])
}

@MainActor
public final class ProfileViewModelImpl: ProfileViewModel {
    
    @Published private(set) public var profile: Types.Profile
    
    @Published private(set) public var specs: [Professions] = []
    @Published private(set) public var companies: [Companies] = []
    @Published public var level: Types.Levels = .no
    
    @Published public var stepsCount: Double = 3
    
    private let onLogoutAction: () -> Void
    //    let profileProvider: ProfileProvider
    
    public init(onLogoutAction: @escaping () -> Void) {
        self.onLogoutAction = onLogoutAction
        self.profile = Profile(id: 0, name: "Алиса Вышегородцева", professions: [], companies: [], level: .no)
    }
    
    
    public func onViewAppear() {
        specs.removeAll()
    }
    
    public func updateSpecs(specs: [Professions]) {
        self.specs = specs
    }
    
    public func updateCompanies(comps: [Companies]) {
        self.companies = comps
    }
    
    public func setSpecLevel(spec: Professions, level: Int) {
        
    }
    
    public func onLogoutTap() {
        onLogoutAction()
    }
    
    public func saveInfo() {
        profile.companies = companies
        profile.professions = specs
        profile.level = level
    }
    
    public func saveNewName(newName: String) {
        
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
    
    //    public func getProfile() -> Types.Profile {
    //        profileProvider.getProfiles()[0]
    //    }
}
