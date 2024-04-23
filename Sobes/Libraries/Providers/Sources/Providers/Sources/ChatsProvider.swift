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
        profiles = profileProvider.getProfiles()
    }

    public func getChats() -> [Types.Chat] {
       return chats
    }

    private var chats: [Types.Chat] = [
        Chat(id: 0, firstResponder: 0, secordResponder: 2, messages: [Message(id: 0, author: 1, text: "Привет, привет!"), Message(id: 1, author: 0, text: "Привет, как у тебя дела?")]),
        Chat(id: 1, firstResponder: 1, secordResponder: 2, messages: [Message(id: 2, author: 0, text: "Привет, привет!"), Message(id: 3, author: 2, text: "Давай на неделе созвонимся и обсудим, как мы готовимся к собеседованиям")])
    ]
    
    public func createNewChat(responderId: Int) {
        let chat = Chat(id: Int.random(in: 0...1000), firstResponder: profileProvider.getCurrentUser().id, secordResponder: responderId, messages: [])
        chats.append(chat)
    }
    
    public func addMessageToChat(chatId: Int, text: String) {
        for i in chats.indices {
            if chats[i].id == chatId {
                chats[i].messages.append(Message(id: Int.random(in: 0...1000), author: profileProvider.getCurrentUser().id, text: text))
            }
        }
    }
}
