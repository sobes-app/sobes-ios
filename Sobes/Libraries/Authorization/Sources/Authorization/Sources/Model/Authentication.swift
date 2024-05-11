import Foundation
import SwiftUI
import SwiftyKeychainKit

public class Authentication: ObservableObject {

    @Published public var isAuth: Bool
    
    public init() {
        let value = try? keychain.get(accessTokenKey)
        isAuth = (value != nil)
    }
    
    public func updateStatus(success: Bool) {
        withAnimation {
            isAuth = success
        }
    }

    private let keychain: Keychain = Keychain(service: "com.swifty.keychain")
    private let accessTokenKey = KeychainKey<String>(key: "accessToken")
}
