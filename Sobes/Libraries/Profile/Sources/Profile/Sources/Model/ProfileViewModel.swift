import Foundation
import Types
import Providers

@MainActor
public protocol ProfileViewModel: ObservableObject {
    var professions: [Professions] {get set}
    var companies: [Companies] {get set}
    var level: Types.Levels {get set}
    var stepsCount: Double {get set}
    
    func getProfileName() -> String
    func getProfileLevel() -> String
    
    func onViewAppear() 
    func onLogoutTap()
    func saveInfo()
    func saveNewName(newName: String)
    func createStringProf() -> String
    func createStringComp() -> String
}

@MainActor
public final class ProfileViewModelImpl: ProfileViewModel {
    let profileProvider: ProfileProvider
    
    @Published var profile: Profile?
    @Published var isLoading = false
    
    @Published public var professions: [Professions] = []
    @Published public var companies: [Companies] = []
    @Published public var level: Types.Levels = .no
    
    @Published public var stepsCount: Double = 3
        
    public init(profileProvider: ProfileProvider) {
        self.profileProvider = profileProvider
        setProfile()
    }
    
    public func getProfileName() -> String {
        return profile?.name ?? "123"
    }
    
    public func getProfileLevel() -> String {
        return profile?.level.rawValue ?? "123"
    }
    
    public func onViewAppear() {
        if profile == nil {
            setProfile()
        }
    }
    
    func setProfile() {
        profileProvider.getProfile(onFinish: { [weak self] result in
            switch result {
            case .success(let success):
                print("success")
                self?.profile = success
            case .failure:
                print("fail")
                break
            }
        })
    }
    
    public func onLogoutTap() {
        profileProvider.logout()
    }
    
    public func saveInfo() {
        
    }
    
    public func saveNewName(newName: String) {

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
