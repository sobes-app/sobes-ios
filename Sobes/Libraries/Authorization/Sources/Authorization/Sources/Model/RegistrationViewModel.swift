import Foundation

@MainActor
public protocol RegistrationViewModel: ObservableObject {
    func onRegisterTap()
    func sendCodetoEmail(email: String)
    func validateCode(code: String) -> Bool
}

@MainActor
public final class RegistrationViewModelImpl: RegistrationViewModel {
    private let onRegistrationComplete: () -> Void
    
    public init(onRegistrationComplete: @escaping () -> Void) {
        self.onRegistrationComplete = onRegistrationComplete
    }
    
    public func onViewAppear() {
    }
    
    public func onRegisterTap() {
        //TODO: создание аккаунта
        onRegistrationComplete()
    }
    
    public func sendCodetoEmail(email: String) {
        
    }
    
    public func validateCode(code: String) -> Bool {
        return true
    }
}
