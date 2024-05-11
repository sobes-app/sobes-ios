import Foundation
import NetworkLayer
import Providers

@MainActor
public protocol AuthViewModel: ObservableObject {   
    var isLoading: Bool {get set}
    var email: String {get set}
    
    func authUser(email: String, password: String) async -> Bool
    func sendCodetoEmail(email: String) async -> Bool
    func validateCode(email: String, code: String) async -> Bool
    func registerUser(email: String, username: String, password: String) async -> Bool
    func sendCodeResetPassword(email: String) async -> Bool
    func updatePassword(password: String) async -> Bool
}

@MainActor
public final class AuthViewModelImpl: AuthViewModel {
    @Published public var isLoading: Bool = false
    @Published public var email: String = ""
    
    private let onLoginComplete: (() -> Void)?
    private let onRegistrationComplete: (() -> Void)?
    private var provider: ProfileProvider
    
    public init(onRegistrationComplete: (() -> Void)? = nil, onLoginComplete: (() -> Void)? = nil, provider: ProfileProvider) {
        self.onRegistrationComplete = onRegistrationComplete
        self.onLoginComplete = onLoginComplete
        self.provider = provider
    }
    
    public func authUser(email:String, password: String) async -> Bool {
        isLoading = true
        let success = await provider.authUser(email: email , password: password)
        isLoading = false
        (onLoginComplete ?? {})()
        return success
    }
    
    public func sendCodeResetPassword(email: String) async -> Bool {
        isLoading = true
        self.email = email
        let success = await provider.recoverAccount(email: email)
        isLoading = false
        return success
    }
    
    public func updatePassword(password: String) async -> Bool {
        isLoading = true
        let success = await provider.forgotPassword(email: email, password: password)
        isLoading = false
        return success
    }
    
    public func registerUser(email: String, username: String, password: String) async -> Bool {
        isLoading = true
        let success = await provider.registerUser(email: email, name: username, password: password)
        isLoading = false
        (onRegistrationComplete ?? {})()
        return success
    }
    
    public func sendCodetoEmail(email: String) async -> Bool {
        isLoading = true
        self.email = email
        let success = await provider.sendEmail(email: email)
        isLoading = false
        return success
    }
    
    public func validateCode(email: String, code: String) async -> Bool {
        isLoading = true
        let success = await provider.verifyCode(email: email, code: code)
        isLoading = false
        return success
    }
}
