//
//  File.swift
//  
//
//  Created by Алиса Вышегородцева on 19.04.2024.
//

import Foundation
import Types

@MainActor
public protocol ProfileViewModel: ObservableObject {
    var specs: [Spec] {get}
    var level: String {get set}
    var stepsCount: Double {get set}
    var profile: Types.Profile {get}
    
    func onViewAppear()
    func updateSpecs(specs: [Spec])
    func setSpecLevel(spec: Spec, level: Int)
    func onLogoutTap()
    func saveInfo()
    func saveNewName(newName: String)
    func createString(array: [String]) -> String
    func updateCompanies(comps: [String])
}

@MainActor
public final class ProfileViewModelImpl: ProfileViewModel {
    
    @Published private(set) public var profile: Types.Profile
    
    @Published private(set) public var specs: [Spec] = []
    @Published private(set) public var companies: [String] = []
    @Published public var level: String = ""
    
    @Published public var stepsCount: Double = 3
    
    private let onLogoutAction: () -> Void
    //    let profileProvider: ProfileProvider
    
    public init(onLogoutAction: @escaping () -> Void) {
        self.onLogoutAction = onLogoutAction
        self.profile = Profile(id: 0, name: "Алиса Вышегородцева", desired: [], companies: [], experience: "")
    }
    
    
    public func onViewAppear() {
        specs.removeAll()
    }
    
    public func updateSpecs(specs: [Spec]) {
        self.specs = specs
    }
    
    public func updateCompanies(comps: [String]) {
        self.companies = comps
    }
    
    public func setSpecLevel(spec: Spec, level: Int) {
        
    }
    
    public func onLogoutTap() {
        onLogoutAction()
    }
    
    public func saveInfo() {
        profile.companies = companies
        profile.desired = getArrayOfSpecs()
        profile.experience = level
    }
    
    func getArrayOfSpecs() -> [String] {
        var array: [String] = []
        for i in specs {
            array.append(i.rawValue)
        }
        return array
    }
    
    public func saveNewName(newName: String) {
        
    }
    
    public func createString(array: [String]) -> String {
        var st = ""
        for ind in array {
            st += ind
            st += ", "
        }
        st.removeLast()
        st.removeLast()
        return st
    }
    
    //    public func getProfile() -> Types.Profile {
    //        profileProvider.getProfiles()[0]
    //    }
}
