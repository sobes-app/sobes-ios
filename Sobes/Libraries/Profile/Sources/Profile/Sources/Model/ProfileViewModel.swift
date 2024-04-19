//
//  File.swift
//  
//
//  Created by Алиса Вышегородцева on 19.04.2024.
//

import Foundation

@MainActor
public protocol ProfileViewModel: ObservableObject {
    var specs: [Spec] {get}
    var stepsCount: Double {get set}
    var step: Double {get set}
    
    func onViewAppear()
    func updateSpecs(specs: [Spec])
    func setSpecLevel(spec: Spec, level: Int)
    func onLogoutTap()
    func saveInfo()
}

@MainActor
public final class ProfileViewModelImpl: ProfileViewModel {
    @Published private(set) public var specs: [Spec] = []
    @Published public var step: Double = 1.0
    @Published public var stepsCount: Double = 0.0
    
    private let onLogoutAction: () -> Void
//    let profileProvider: ProfileProvider
    
    public init(onLogoutAction: @escaping () -> Void) {
        self.onLogoutAction = onLogoutAction
    }
    
    
    public func onViewAppear() {
        specs.removeAll()
    }
    
    public func updateSpecs(specs: [Spec]) {
        self.specs = specs
    }
    
    public func setSpecLevel(spec: Spec, level: Int) {
        
    }
    
    public func onLogoutTap() {
        onLogoutAction()
    }
    
    public func saveInfo() {
        
    }
    
//    public func getProfile() -> Types.Profile {
//        profileProvider.getProfiles()[0]
//    }
}
