import SwiftUI
import Types
import Providers
import NetworkLayer

public enum FilterType {
    case company
    case profession
    case level
}

@MainActor
public protocol ChatViewModel: ObservableObject {
    var chats: [Chat]? {get}
    var profiles: [Profile]? {get}
    var messageId: Int {get set}
    var isLoading: Bool {get set}
    var isError: Bool {get set}
    
    var expFilter: [Filter] {get set}
    var desFilter: [Filter] {get set}
    var comFilter: [Filter] {get set}
    var filters: [Types.Filter] { get set }
    
    func onViewAppear() async
    func getProfiles() async
    func clearFilters() async
    func createNewChat(reponder: Profile)
    func onFilterTapped(id: Int, type: FilterType)
    func getResponder(chat: Chat) -> Profile
    func addMessageToChat(chatId: Int, text: String)
    func checkChatExistance(responder: Profile) -> Bool
    func filtersNotActive() -> Bool
    func getChatByResponder(responder: Profile) -> Chat
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
    
    public init(profileProvider: ProfileProvider, chatProvider: ChatsProvider) {
        self.filters = []
        
        self.comFilter = []
        self.expFilter = []
        self.desFilter = []
        
        self.profilesProvider = profileProvider
        self.chatProvider = chatProvider
        
        initFilters()
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
            case .unauthorized:
                let update = await profilesProvider.updateToken()
                if update {
                    _ = await profilesProvider.getProfile()
                    await getProfiles()
                } else {
                    isError = true
                }
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
    }
    
    public func getResponder(chat: Chat) -> Profile {
        if profilesProvider.getCurrentUser().id == chat.firstResponderId {
            let profile = profilesProvider.getProfiles().first(where: {$0.id == chat.secondResponderId})
            return profile ?? profilesProvider.getCurrentUser()
        }
        let profile = profilesProvider.getProfiles().first(where: {$0.id == chat.firstResponderId})
        return profile ?? profilesProvider.getCurrentUser()
    }
    
    public func addMessageToChat(chatId: Int, text: String) {
        chatProvider.addMessageToChat(chatId: chatId, text: text)
        fetchChats()
    }
    
    public func checkChatExistance(responder: Profile) -> Bool {
        return chats?.first(where: {$0.firstResponderId == responder.id || $0.secondResponderId == responder.id}) != nil
    }
    
    public func createNewChat(reponder: Profile) {
        chatProvider.createNewChat(responderId: reponder.id)
        fetchChats()
    }
    
    public func getChatByResponder(responder: Profile) -> Chat {
        return chats?.first(where: {$0.firstResponderId == responder.id  || $0.secondResponderId == responder.id}) ?? chats![0]
    }
    
    
    func fetchChats() {
        chats = chatProvider.getChats()
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
}
