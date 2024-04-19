//
//  File.swift
//  
//
//  Created by Алиса Вышегородцева on 19.04.2024.
//

import Foundation

@MainActor
public protocol LoginViewModel: ObservableObject {
    func onLoginTap()
    func sendCodeToEmail(email: String)
    func validateCode(code: String) -> Bool
    func updatePassword(newPassword: String, repeatPassword: String) -> Bool
}

@MainActor
public final class LoginViewModelImpl: LoginViewModel {
    private let onLoginComplete: () -> Void
    
    public init(onLoginComplete: @escaping () -> Void) {
        self.onLoginComplete = onLoginComplete
    }
    
    public func onViewAppear() {
    }
    
    public func onLoginTap() {
        onLoginComplete()
    }
    
    public func sendCodeToEmail(email: String) {
        
    }
    
    public func validateCode(code: String) -> Bool {
        return true
    }
    
    public func updatePassword(newPassword: String, repeatPassword: String) -> Bool {
        if newPassword == repeatPassword {
            onLoginTap()
            return true
        } else {
            return false
        }
    }
}
