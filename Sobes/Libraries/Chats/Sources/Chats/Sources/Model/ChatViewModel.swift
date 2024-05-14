import SwiftUI
import Types
import Providers
import NetworkLayer
import SwiftyKeychainKit

public enum FilterType {
    case company
    case profession
    case level
}

@MainActor
public protocol ChatViewModel: ObservableObject {
    var chats: [Chat]? {get set}
    var profiles: [Profile]? {get}
    var messages: [Types.Message] {get set}
    var messageId: Int {get set}
    var isLoading: Bool {get set}
    var isError: Bool {get set}
    
    var expFilter: [Filter] {get set}
    var desFilter: [Filter] {get set}
    var comFilter: [Filter] {get set}
    var filters: [Types.Filter] { get set }
    
    func onViewAppear() async
    func getProfiles() async
    func getChats() async
    func clearFilters() async
    func getCurrentUserId() -> Int
    func createNewChat(responder: Profile) async -> Chat
    func onFilterTapped(id: Int, type: FilterType)
    func getResponder(chat: Chat) -> Profile
    func checkChatExistance(responder: Profile) -> Bool
    func filtersNotActive() -> Bool
    func getChatByResponder(responder: Profile) -> Chat
    func fetchMessages(chatId: Int) async -> [Types.Message]
    func deleteChat(chatId: Int) async
    func readMessages(chat: Chat) async
    
    func getAccessToken() -> String
    
    // Socket Service
    func connect()
    func disconnect()
    func sendChatMessage(chatId: Int, senderId: Int, text: String)
}

@MainActor
public final class ChatViewModelImpl: ChatViewModel {
    
    let profilesProvider: ProfileProvider
    let chatProvider: ChatsProvider
    
    @Published public var isLoading: Bool = false
    @Published public var isError: Bool = false
    
    @Published public var chats: [Chat]?
    @Published public var profiles: [Profile]?
    @Published public var filters: [Types.Filter]
    @Published public var messageId: Int = 8
    
    @Published public var expFilter: [Filter]
    @Published public var desFilter: [Filter]
    @Published public var comFilter: [Filter]
    
    //SocketService
    
    @Published public var messages: [Types.Message] = []
    
    private var webSocketTask: URLSessionWebSocketTask?
    let urlSession = URLSession(configuration: .default)
    var isConnected = false
    
    public init(profileProvider: ProfileProvider, chatProvider: ChatsProvider) {
        self.filters = []
        
        self.comFilter = []
        self.expFilter = []
        self.desFilter = []
        
        self.profilesProvider = profileProvider
        self.chatProvider = chatProvider
        
        initFilters()
    }
    
    public func getCurrentUserId() -> Int {
        return profilesProvider.profile?.id ?? 0
    }
    
    public func onFilterTapped(id: Int, type: FilterType) {
        filters[id].isActive.toggle()
        toggleProfileFilter(type: type, id: id)
        if filtersNotActive() {
            profiles = profilesProvider.getProfiles()
        } else {
            var filteredProfiles: [Types.Profile] = []
            let activeFilters: [Filter] = filters.filter { item in
                item.isActive
            }
            for profile in profiles ?? [] {
                var append: Bool = false
                for filter in activeFilters {
                    if (Profile.createStringOfCompanies(of: profile).contains(filter.name) || Profile.createStringOfProfessions(of: profile).contains(filter.name) || profile.level.rawValue == filter.name) {
                        append = true
                    } else {
                        append = false
                        break
                    }
                }
                if append {
                    filteredProfiles.append(profile)
                }
            }
            profiles = filteredProfiles
        }
    }
    
    public func clearFilters() async {
        initFilters()
        for i in 0...filters.count-1 {
            if(filters[i].isActive) {
                filters[i].isActive.toggle()
            }
        }
        await getProfiles()
    }
    
    public func filtersNotActive() -> Bool {
        for filter in filters {
            if filter.isActive {
                return false
            }
        }
        return true
    }
    
    public func getProfiles() async {
        isLoading = true
        defer { isLoading = false }
        
        let result = await chatProvider.getProfiles()
        switch result {
        case .success(let success):
            profiles = success
        case .failure(let error):
            switch error {
            case .empty:
                profiles = []
            case .error:
                isError = true
            }
        }
    }
    
    func sortChats() {
        var sortedChats = chats ?? []
        sortedChats.sort(by: { chat1, chat2 in
            guard let lastMessage1 = chat1.messages.last else { return false }
            guard let lastMessage2 = chat2.messages.last else { return true }
            return lastMessage1.date > lastMessage2.date
        })
        chats = sortedChats
    }
    
    public func getChats() async {
        isLoading = true
        defer { isLoading = false }
        
        let result = await chatProvider.getChats()
        switch result {
        case .success(let success):
            chats = success
            sortChats()
        case .failure(let error):
            switch error {
            case .empty:
                chats = []
            case .error:
                isError = true
            }
        }
    }
    
    public func onViewAppear() async {
        if profilesProvider.profile == nil {
            _ = await profilesProvider.getProfile()
        }
        if profiles == nil {
            await getProfiles()
        }
        if chats == nil {
            await getChats()
        }
    }
    
    public func getResponder(chat: Chat) -> Profile {
        if profilesProvider.getCurrentUser().id == chat.firstResponderId {
            let profile = profiles?.first(where: {$0.id == chat.secondResponderId})
            return profile ?? Profile()
        }
        let profile = profiles?.first(where: {$0.id == chat.firstResponderId})
        return profile ?? Profile()
    }
    
    
    public func checkChatExistance(responder: Profile) -> Bool {
        return chats?.first(where: {$0.firstResponderId == responder.id || $0.secondResponderId == responder.id}) != nil
    }
    
    public func createNewChat(responder: Profile) async -> Chat {
        isLoading = true
        defer { isLoading = false }
        
        let result = await chatProvider.createNewChat(responderId: responder.id)
        switch result {
        case .success(let chat):
            chats = chatProvider.chats
            return chat
        case .failure(let error):
            switch error {
            case .empty:
                chats = []
            case .error:
                isError = true
            }
            return Chat()
        }
    }
    
    public func deleteChat(chatId: Int) async {
        let result = await chatProvider.deleteChat(chatId: chatId)
        switch result {
        case .success:
            return
        case .failure(let failure):
            switch failure {
            case .empty:
                chats = []
            case .error:
                isError = true
            }
        }
    }
    
    public func getChatByResponder(responder: Profile) -> Chat {
        return chats?.first(where: {$0.firstResponderId == responder.id  || $0.secondResponderId == responder.id}) ?? chats![0]
    }
    
    func initFilters() {
        let companyNames = Companies.allCases.filter {$0 != .no}
        let levelNames = Levels.allCases.filter {$0 != .no}
        let professionNames = Professions.allCases.filter {$0 != .no}
        
        let companies = companyNames.enumerated().map { index, company in
            Filter(id: index, name: company.rawValue)
        }
        
        let levels = levelNames.enumerated().map { index, level in
            Filter(id: companyNames.count + index, name: level.rawValue)
        }
        
        let professions = professionNames.enumerated().map { index, profession in
            Filter(id: companyNames.count + levelNames.count + index, name: profession.rawValue)
        }
        
        comFilter = companies
        expFilter = levels
        desFilter = professions
        
        filters = [comFilter, expFilter, desFilter].flatMap { $0 }
    }
    
    func toggleProfileFilter(type: FilterType, id: Int) {
        switch type {
            case .company:
                if let index = comFilter.firstIndex(where: { $0.id == id }) {
                    comFilter[index].isActive.toggle()
                }
            case .profession:
                if let index = desFilter.firstIndex(where: { $0.id == id }) {
                    desFilter[index].isActive.toggle()
                }
            case .level:
                if let index = expFilter.firstIndex(where: { $0.id == id }) {
                    expFilter[index].isActive.toggle()
                }
        }
    }
    
    public func getAccessToken() -> String {
        return (try? keychain.get(accessTokenKey)) ?? ""
    }
    
    public func fetchMessages(chatId: Int) async -> [Types.Message] {
        isLoading = true
        defer { isLoading = false }
        
        let result = await chatProvider.getChatMessages(chatId: chatId)
        switch result {
        case .success(let success):
            messages = success
            return success
        case .failure(let error):
            switch error {
            case .empty:
                messages = []
            case .error:
                isError = true
            }
            return []
        }
    }
    
    public func readMessages(chat: Chat) async {
        let idsArray = chat.messages.map({ message in
            return message.messageId
        })
        
        await chatProvider.readMessages(messages: idsArray)
    }
    
    public func connect() {
        let url = URL(string: "ws://localhost:8085/ws/chat")!
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessage()
        sendConnectFrame()
    }
    
    public func disconnect() {
        sendDisconnectFrame()
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
    func subscribeToTopic(topic: String) {
        let subscribeFrame = "SUBSCRIBE\nid:sub-0\ndestination:\(topic)\n\n\0"
        _ = sendMessage(text: subscribeFrame)
    }

    func sendConnectFrame() {
        let connectFrame = "CONNECT\naccept-version:1.2\nheart-beat:10000,10000\nAuthorization:Bearer \(getAccessToken())\n\n\0"
        _ = sendMessage(text: connectFrame)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.subscribeToTopic(topic: "/topic/messages")
        }
    }
    
    func sendDisconnectFrame() {
        let disconnectFrame = "DISCONNECT\n\n\0"
        _ = sendMessage(text: disconnectFrame)
    }
    
    func sendMessage(text: String) -> Bool {
        var success: Bool = true
        let message = URLSessionWebSocketTask.Message.string(text)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("Error sending message: \(error)")
                success = false
            }
        }
        return success
    }
    
    func parseMessageResponse(text: String) -> Bool {
        guard let range = text.range(of: "\\{.*\\}", options: .regularExpression),
              let jsonData = String(text[range]).data(using: .utf8) else {
            return false
        }
        
        var success = false
        
        DispatchQueue.main.async {
            do {
                let messagesResponse = try JSONDecoder().decode(MessagesResponse.self, from: jsonData)
                print(messagesResponse)
                let isCurrentUser = messagesResponse.sender.id == self.profilesProvider.getCurrentUser().id
                let message = Types.Message(messageResponse: messagesResponse, isCurrent: isCurrentUser)
                
                if var chats = self.chats,
                   let chatIndex = chats.firstIndex(where: { $0.id == messagesResponse.chatId }) {
                        self.messages.append(message)
                    withAnimation {
                        chats[chatIndex].messages.append(message)
                        self.chats = chats
                        self.sortChats()
                    }
                    success = true
                } else {
                    Task { @MainActor [weak self] in
                        guard let self else {return}
                        await getChats()
                    }
                }
            } catch {
                print(error)
            }
        }
        return success
    }

    func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("Error in receiving message: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    _ = self?.parseMessageResponse(text: text)
                case .data(let data):
                    print("Received data: \(data)")
                @unknown default:
                    fatalError()
                }
                self?.receiveMessage()
            }
        }
    }
    
    public func sendChatMessage(chatId: Int, senderId: Int, text: String) {
        let message = "SEND\ndestination:/app/send\ncontent-type:application/json\n\n{\"chatId\":\"\(chatId)\",\"senderId\":\"\(senderId)\",\"text\":\"\(text)\"}\0"
        _ = sendMessage(text: message)
    }
    
    private let keychain: Keychain = Keychain(service: "com.swifty.keychain")
    private let accessTokenKey = KeychainKey<String>(key: "accessToken")
}
