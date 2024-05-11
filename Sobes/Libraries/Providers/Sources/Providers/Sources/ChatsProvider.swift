import Foundation
import Types
import NetworkLayer
import SwiftyKeychainKit

public protocol ChatsProvider {
    var profiles: [Profile]? {get set}
    var chats: [Chat]? {get set}
    
    func getChats() -> [Types.Chat]
    func addMessageToChat(chatId: Int, text: String)
    func createNewChat(responderId: Int)
    
    func getProfiles() async -> Result<[Profile], CustomError>
}

public final class ChatsProviderImpl: ChatsProvider {
    let profileProvider: ProfileProvider
    public var profiles: [Profile]?
    public var chats: [Chat]?

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
            switch failure {
            case .httpError(let code):
                if code == 404 {
                    return .failure(.empty)
                }
                return .failure(.error)
            case .noDataError:
                return .failure(.empty)
            case .jsonDecodeError, .jsonEncodeError, .responseError:
                return .failure(.error)
            }
        }
    }

    public func getChats() -> [Types.Chat] {
       return chats ?? []
    }
    
    public func createNewChat(responderId: Int) {

    }
    
    public func addMessageToChat(chatId: Int, text: String) {

    }
}
