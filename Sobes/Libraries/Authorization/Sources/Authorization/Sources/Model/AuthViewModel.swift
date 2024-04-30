import Foundation
import NetworkLayer
import Providers

@MainActor
public protocol AuthViewModel: ObservableObject {   
    var isLoading: Bool {get set}
    
    func sendCodetoEmail(email: String) async -> Bool
    func validateCode(code: String) async -> Bool
    func registerUser(username: String, password: String) async -> Bool
    
    func onLoginTap(email:String, password: String) async -> Bool
    func sendCodeResetPassword(email: String)
    func validateCode(code: String) -> Bool
    func updatePassword(newPassword: String, repeatPassword: String) -> Bool
}

@MainActor
public final class AuthViewModelImpl: AuthViewModel {
    @Published public var isLoading: Bool = false
    
    private let onLoginComplete: (() -> Void)?
    private let onRegistrationComplete: (() -> Void)?
    private var provider: ProfileProvider
    
    public init(onRegistrationComplete: (() -> Void)? = nil, onLoginComplete: (() -> Void)? = nil, provider: ProfileProvider) {
        self.onRegistrationComplete = onRegistrationComplete
        self.onLoginComplete = onLoginComplete
        self.provider = provider
    }
    
    public func onLoginTap(email:String, password: String) async -> Bool {
        isLoading = true
        let auth = await provider.authUser(email: email , password: password)
        isLoading = false
        return auth
    }
    
    public func sendCodeResetPassword(email: String) {
        
    }
    
    public func validateCode(code: String) -> Bool {
        return true
    }
    
    public func updatePassword(newPassword: String, repeatPassword: String) -> Bool {
        return true
    }
    
    public func registerUser(username: String, password: String) async -> Bool {
        return await provider.registerUser(name: username, password: password)
    }
    
    public func sendCodetoEmail(email: String) async -> Bool {
        return await provider.sendEmail(email: email)
    }
    
    public func validateCode(code: String) async -> Bool {
        return await provider.verifyCode(code: code)
    }
}
