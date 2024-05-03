import Foundation
import Types
import NetworkLayer
import SwiftyKeychainKit

public protocol ChatsProvider {
    var profiles: [Profile]? {get set}
    
    func getChats() -> [Types.Chat]
    func addMessageToChat(chatId: Int, text: String)
    func createNewChat(responderId: Int)
    
    func getProfiles() async -> Result<[Profile], ClientError>
}

public final class ChatsProviderImpl: ChatsProvider {
    let profileProvider: ProfileProvider
    public var profiles: [Profile]?
    
    private let keychain: Keychain = Keychain(service: "com.swifty.keychain")
    private let accessTokenKey = KeychainKey<String>(key: "accessToken")
    private let refreshTokenKey = KeychainKey<String>(key: "refreshToken")
    private let tokenType = KeychainKey<String>(key: "tokenType")

    public init(profileProvider: ProfileProvider) {
        self.profileProvider = profileProvider
    }
    
    public func getProfiles() async -> Result<[Profile], ClientError> {
        let chatsClient = ChatsClient(token: try? self.keychain.get(accessTokenKey), tokenType: try? self.keychain.get(tokenType))
        let result = await chatsClient.getProfiles()
        switch result {
        case .success(let success):
            var arrayProfiles: [Profile] = []
            for i in success.indices {
                if success[i].id != profileProvider.profile?.id {
                    arrayProfiles.append(Profile(profileResponse: success[i]))
                }
            }
            profiles = arrayProfiles
            return .success(arrayProfiles)
        case .failure(let failure):
            return .failure(failure)
        }
        
    }

    public func getChats() -> [Types.Chat] {
       return chats
    }

    private var chats: [Types.Chat] = [

    ]
    
    public func createNewChat(responderId: Int) {

    }
    
    public func addMessageToChat(chatId: Int, text: String) {

    }
}
