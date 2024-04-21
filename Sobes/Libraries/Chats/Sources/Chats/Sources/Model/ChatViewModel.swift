import SwiftUI
import Types

@MainActor
public protocol ChatViewModel: ObservableObject {
    var chats: [Chat] {get}
    var profileId: Int {get}
    var messageId: Int {get set}
    
    func onViewAppear()
    func getResponder(chat: Chat) -> Profile
    func getLastMessage(chat: Chat) -> String
    func addMessageToChat(chatId: Int, text: String)
}

@MainActor
public final class ChatViewModelImpl: ChatViewModel {
    
    @Published public var chats: [Chat]
    @Published private(set) public var profileId: Int
    @Published public var messageId: Int = 5
    
    public init(profileId: Int) {
        self.chats = []
        self.profileId = profileId
    }
    
    public func onViewAppear() {
        chats = getDefaultChats()
    }
    
    public func getResponder(chat: Chat) -> Profile {
        if profileId == chat.firstResponder.id {
            return chat.secondResponder
        }
        return chat.firstResponder
    }
    
    public func getLastMessage(chat: Chat) -> String {
        if chat.messages.last?.author == profileId {
            return "me: " + (chat.messages.last?.text ?? "")
        }
        return chat.messages.last?.text ?? ""
    }
    
    func getDefaultChats() -> [Chat] {
        let profile1 = Profile(id: 1, name: "Яна Барбашина", desired: ["Менеджер продукта"], companies: ["Тинькофф"], experience: "Стажировка")
        let profile2 = Profile(id: 2, name: "Даяна Тасбауова", desired: ["Бизнес аналитик"], companies: ["Яндекс", "Другое"], experience: "Jun/Jun+")
        let profile3 = Profile(id: 0, name: "Алиса Вышегородцева", desired: [], companies: [], experience: "")
        
        let chat1 = Chat(id: 0, firstResponder: profile1, secordResponder: profile3, messages: [Message(id: 0, author: 1, text: "Привет, привет!"), Message(id: 1, author: 0, text: "Привет, как у тебя дела?")])
        let chat2 = Chat(id: 1, firstResponder: profile2, secordResponder: profile3, messages: [Message(id: 2, author: 0, text: "Привет, привет!"), Message(id: 3, author: 2, text: "Давай на неделе созвонимся и обсудим, как мы готовимся к собеседованиям")])
        return [chat1,chat2]
    }
    
    public func addMessageToChat(chatId: Int, text: String) {
        chats[chatId].messages.append(Message(id: messageId, author: profileId, text: text))
        messageId += 1
    }
}
