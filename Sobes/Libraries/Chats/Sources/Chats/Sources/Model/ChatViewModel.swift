import SwiftUI
import Types
import Providers

public enum FilterType {
    case company
    case profession
    case level
}

@MainActor
public protocol ChatViewModel: ObservableObject {
    var chats: [Chat] {get}
    var profiles: [Profile] {get}
    var messageId: Int {get set}
    
    var expFilter: [Filter] {get set}
    var desFilter: [Filter] {get set}
    var comFilter: [Filter] {get set}
    var filters: [Types.Filter] { get set }
    
    func onViewAppear()
    func clearFilters()
    func createNewChat(reponder: Profile)
    func onFilterTapped(id: Int, type: FilterType)
    func getCurrentUser() -> Profile
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
    
    @Published public var chats: [Chat]
    @Published public var profiles: [Profile]
    @Published public var filters: [Types.Filter]
    @Published public var messageId: Int = 5
    
    @Published public var expFilter: [Filter]
    @Published public var desFilter: [Filter]
    @Published public var comFilter: [Filter]
    
    
    public init(profileProvider: ProfileProvider, chatProvider: ChatsProvider) {
        self.chats = []
        self.profiles = []
        self.filters = []
        
        self.comFilter = []
        self.expFilter = []
        self.desFilter = []
        
        self.profilesProvider = profileProvider
        self.chatProvider = chatProvider
        profiles = profileProvider.getProfiles()
        
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
            for profile in profiles {
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
    
    public func clearFilters() {
        initFilters()
        for i in 0...filters.count-1 {
            if(filters[i].isActive) {
                filters[i].isActive.toggle()
            }
        }
        profiles = profilesProvider.getProfiles()
    }
    
    public func filtersNotActive() -> Bool {
        for filter in filters {
            if filter.isActive {
                return false
            }
        }
        return true
    }
    
    public func getCurrentUser() -> Profile {
        return profilesProvider.getCurrentUser()
    }
    
    public func onViewAppear() {
        chats = chatProvider.getChats()
    }
    
    public func getResponder(chat: Chat) -> Profile {
        if profilesProvider.getCurrentUser().id == chat.firstResponderId {
            return profiles.first(where: {$0.id == chat.secondResponderId}) ?? profilesProvider.getCurrentUser()
        }
        return profiles.first(where: {$0.id == chat.firstResponderId}) ?? profilesProvider.getCurrentUser()
    }
    
    public func addMessageToChat(chatId: Int, text: String) {
        chatProvider.addMessageToChat(chatId: chatId, text: text)
        fetchChats()
    }
    
    public func checkChatExistance(responder: Profile) -> Bool {
        return chats.first(where: {$0.firstResponderId == responder.id || $0.secondResponderId == responder.id}) != nil
    }
    
    public func createNewChat(reponder: Profile) {
        chatProvider.createNewChat(responderId: reponder.id)
        fetchChats()
    }
    
    public func getChatByResponder(responder: Profile) -> Chat {
        return chats.first(where: {$0.firstResponderId == responder.id || $0.secondResponderId == responder.id}) ?? chats[0]
    }
    
    func fetchChats() {
        chats = chatProvider.getChats()
    }
    
    func initFilters() {
        comFilter = [
            Filter(id: 0, name: Companies.yandex.rawValue),
            Filter(id: 1, name: Companies.tinkoff.rawValue),
            Filter(id: 2, name: Companies.other.rawValue),
        ]
        
        expFilter = [
            Filter(id: 3, name: Levels.inter.rawValue),
            Filter(id: 4, name: Levels.jun.rawValue),
            Filter(id: 5, name: Levels.mid.rawValue),
            Filter(id: 6, name: Levels.sen.rawValue)
        ]
        
        desFilter = [
            Filter(id: 7, name: Professions.project.rawValue),
            Filter(id: 8, name: Professions.product.rawValue),
            Filter(id: 9, name: Professions.analyst.rawValue)
        ]
        
        filters.append(contentsOf: comFilter)
        filters.append(contentsOf: expFilter)
        filters.append(contentsOf: desFilter)
    }
    
    func toggleProfileFilter(type: FilterType, id: Int) {
        switch type {
        case .company:
            for i in 0...comFilter.count - 1 {
                if comFilter[i].id == id {
                    comFilter[i].isActive.toggle()
                }
            }
        case .profession:
            for i in 0...desFilter.count - 1 {
                if desFilter[i].id == id {
                    desFilter[i].isActive.toggle()
                }
            }
        case .level:
            for i in 0...expFilter.count - 1 {
                if expFilter[i].id == id {
                    expFilter[i].isActive.toggle()
                }
            }
        }
    }
}
