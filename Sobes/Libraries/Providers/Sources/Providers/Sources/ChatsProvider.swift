import Foundation
import Types
import NetworkLayer
import SwiftyKeychainKit

public protocol ChatsProvider {
    var profiles: [Profile]? {get set}
    var chats: [Chat]? {get set}
    var currentChat: Chat? {get set}
    
    func addMessageToChat(chatId: Int, text: String)
    func createNewChat(responderId: Int) async -> Result<Chat, CustomError>
    func deleteChat(chatId: Int) async -> Result<Bool, CustomError>
    
    func getProfiles() async -> Result<[Profile], CustomError>
    func getChats() async -> Result<[Chat], CustomError>
    func getChatMessages(chatId: Int) async -> Result<[Types.Message], CustomError>
    func readMessages(messages: [Int]) async
}

public final class ChatsProviderImpl: ChatsProvider {
    let profileProvider: ProfileProvider
    public var profiles: [Profile]?
    public var chats: [Chat]?
    public var currentChat: Chat?

    public init(profileProvider: ProfileProvider) {
        self.profileProvider = profileProvider
    }
    
    public func getProfiles() async -> Result<[Profile], CustomError> {
        let chatsClient = ChatsClient()
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
            return .failure(handleError(failure: failure))
        }
    }

    public func getChats() async -> Result<[Chat], CustomError> {
        let chatsClient = ChatsClient()
        let result = await chatsClient.getChats()
        switch result {
        case .success(let success):
            var arrayChats: [Chat] = []
            for i in success.indices {
                var chat = Chat(chat: success[i])
                let resultOfMessages = await getChatMessages(chatId: chat.id)
                switch resultOfMessages {
                case .success(let success):
                    chat.messages = success
                case .failure:
                    chat.messages = []
                }
                if !chat.messages.isEmpty {
                    arrayChats.append(chat)
                }
            }
            chats = arrayChats
            return .success(arrayChats)
        case .failure(let failure):
            print(failure)
            return .failure(handleError(failure: failure))
        }
    }
    
    public func createNewChat(responderId: Int) async -> Result<Chat, CustomError> {
        let chatsClient = ChatsClient()
        let result = await chatsClient.createChat(userId: responderId)
        switch result {
        case .success(let success):
            print(success)
            let newChat = Chat(chat: success)
            chats?.append(newChat)
            return .success(newChat)
        case .failure(let failure):
            return .failure(handleError(failure: failure))
        }
    }
    
    public func getChatMessages(chatId: Int) async -> Result<[Types.Message], CustomError> {
        let chatsClient = ChatsClient()
        let result = await chatsClient.getMessages(chatId: chatId)
        switch result {
        case .success(let success):
            var messagesArray: [Types.Message] = []
            let profileId = profileProvider.profile?.id
            for i in success.indices {
                messagesArray.append(Message(messageResponse: success[i], isCurrent: success[i].sender.id == profileId))
            }
            return .success(messagesArray)
        case .failure(let failure):
            return .failure(handleError(failure: failure))
        }
    }
    
    public func deleteChat(chatId: Int) async -> Result<Bool, CustomError> {
        let chatsClient = ChatsClient()
        let result = await chatsClient.deleteChat(chatId: chatId)
        switch result {
        case .success:
            var newChats: [Chat] = []
            for i in 0..<(chats?.count ?? 0) {
                if chats?[i].id != chatId {
                    newChats.append(chats?[i] ?? Chat())
                }
            }
            self.chats = newChats
            return .success(true)
        case .failure(let error):
            return .failure(handleError(failure: error))
        }
    }
    
    public func readMessages(messages: [Int]) async {
        let chatsClient = ChatsClient()
        _ = await chatsClient.readMessages(messages: messages)
    }
    
    func handleError(failure: ClientError) -> CustomError {
        switch failure {
        case .httpError(let code):
            print(code)
            if code == 404 {
                return .empty
            }
            return .error
        case .noDataError:
            return .empty
        case .jsonDecodeError, .jsonEncodeError, .responseError:
            return .error
        }
    }
    
    public func addMessageToChat(chatId: Int, text: String) {

    }
}
