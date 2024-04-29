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
        Chat(id: 0, firstResponder: 0, secordResponder: 2, messages: [Message(id: 0, isCurrentUser: false, text: "Привет, привет!"), Message(id: 1, isCurrentUser: true, text: "Привет, как у тебя дела?")]),
        Chat(id: 1, firstResponder: 1, secordResponder: 0, messages: [Message(id: 2, isCurrentUser: true, text: "Привет, привет!"), Message(id: 3, isCurrentUser: false, text: "Давай на неделе созвонимся и обсудим, как мы готовимся к собеседованиям"), Message(id: 4, isCurrentUser: true, text: "Давай, я напишу тебе в понедельник, как буду свободна, а то мне нудно готовиться к сдаче преддипломной практики, окей?"), Message(id: 5, isCurrentUser: false, text: "Без проблем, удачи тебе, много осталось готовить?...."), Message(id: 6, isCurrentUser: true, text: "Не особо, вот уже демонстрацию записываю:)"), Message(id: 7, isCurrentUser: false, text: "круто")])
    ]
    
    public func createNewChat(responderId: Int) {
        let chat = Chat(id: Int.random(in: 0...1000), firstResponder: profileProvider.getCurrentUser().id, secordResponder: responderId, messages: [])
        chats.append(chat)
    }
    
    public func addMessageToChat(chatId: Int, text: String) {
        for i in chats.indices {
            if chats[i].id == chatId {
                chats[i].messages.append(Message(id: Int.random(in: 0...1000), isCurrentUser: true, text: text))
            }
        }
    }
}
