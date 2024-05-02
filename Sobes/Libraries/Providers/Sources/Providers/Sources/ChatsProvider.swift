import Foundation
import Types

public protocol ChatsProvider {
    func getChats() -> [Types.Chat]
    func addMessageToChat(chatId: Int, text: String)
    func createNewChat(responderId: Int)
}

public final class ChatsProviderImpl: ChatsProvider {
    let profileProvider: ProfileProvider
    let profiles: [Profile]

    public init(profileProvider: ProfileProvider) {
        self.profileProvider = profileProvider
        profiles = []
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
