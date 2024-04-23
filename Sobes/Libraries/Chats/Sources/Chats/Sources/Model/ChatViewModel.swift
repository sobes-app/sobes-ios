import SwiftUI
import Types

public enum FilterType {
    case company
    case profession
    case level
}

@MainActor
public protocol ChatViewModel: ObservableObject {
    var chats: [Chat] {get}
    var profiles: [Profile] {get}
    var profileId: Int {get}
    var messageId: Int {get set}
    
    var expFilter: [Filter] {get set}
    var desFilter: [Filter] {get set}
    var comFilter: [Filter] {get set}
    var filters: [Types.Filter] { get set }
    
    func onViewAppear()
    func clearFilters()
    func onFilterTapped(id: Int, type: FilterType)
    func getResponder(chat: Chat) -> Profile
    func addMessageToChat(chatId: Int, text: String)
    func filtersNotActive() -> Bool
    func getChatByResponderOrCreateNew(responder: Profile) -> Chat
}

@MainActor
public final class ChatViewModelImpl: ChatViewModel {
    
    @Published public var chats: [Chat]
    @Published public var profiles: [Profile]
    @Published public var filters: [Types.Filter]
    @Published private(set) public var profileId: Int
    @Published public var messageId: Int = 5
    
    @Published public var expFilter: [Filter]
    @Published public var desFilter: [Filter]
    @Published public var comFilter: [Filter]
    
    public init(profileId: Int) {
        self.chats = []
        self.profileId = profileId
        self.profiles = []
        self.filters = []
        
        self.comFilter = []
        self.expFilter = []
        self.desFilter = []
        
        profiles = getDefaultProfiles()
        chats = getDefaultChats()
        initFilters()
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
    
    public func onFilterTapped(id: Int, type: FilterType) {
        filters[id].isActive.toggle()
        toggleProfileFilter(type: type, id: id)
        if filtersNotActive() {
            profiles = getDefaultProfiles()
        } else {
            var filteredProfiles: [Types.Profile] = []
            for profile in profiles {
                var append: Bool = false
                for filter in filters {
                    // переписать, чтобы совпадали все фильтры
                    if filter.isActive && (Profile.createStringOfCompanies(of: profile).contains(filter.name) || Profile.createStringOfProfessions(of: profile).contains(filter.name) || profile.level.rawValue == filter.name) {
                        append = true
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
        profiles = getDefaultProfiles()
    }
    
    public func filtersNotActive() -> Bool {
        for filter in filters {
            if filter.isActive {
                return false
            }
        }
        return true
    }
    
    public func onViewAppear() {

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
    
    public func getResponder(chat: Chat) -> Profile {
        if profileId == chat.firstResponder.id {
            return chat.secondResponder
        }
        return chat.firstResponder
    }
    
    func getDefaultProfiles() -> [Profile] {
        let profile1 = Profile(id: 1, name: "Яна Барбашина", professions: [.product], companies: [.tinkoff], level: .inter)
        let profile2 = Profile(id: 2, name: "Даяна Тасбауова", professions: [.project, .analyst], companies: [.yandex, .other], level: .jun)
        let profile3 = Profile(id: 0, name: "Алиса Вышегородцева", professions: [], companies: [], level: .no)
        let profile4 = Profile(id: 3, name: "Колобок", professions: [.product, .project, .analyst], companies: [], level: .sen)
        let profile5 = Profile(id: 4, name: "Лисица", professions: [.product, .project], companies: [.tinkoff,.other], level: .mid)
        
        return [profile1, profile2, profile3, profile4, profile5]
    }
    
    func getDefaultChats() -> [Chat] {
        let chat1 = Chat(id: 0, firstResponder: profiles[0], secordResponder: profiles[2], messages: [Message(id: 0, author: 1, text: "Привет, привет!"), Message(id: 1, author: 0, text: "Привет, как у тебя дела?")])
        let chat2 = Chat(id: 1, firstResponder: profiles[1], secordResponder: profiles[2], messages: [Message(id: 2, author: 0, text: "Привет, привет!"), Message(id: 3, author: 2, text: "Давай на неделе созвонимся и обсудим, как мы готовимся к собеседованиям")])
        return [chat1,chat2]
    }
    
    public func addMessageToChat(chatId: Int, text: String) {
        chats[chatId].messages.append(Message(id: messageId, author: profileId, text: text))
        messageId += 1
    }
    
    func getProfileById(id: Int) -> Profile {
        for i in profiles {
            if i.id == id {
                return i
            }
        }
        return profiles[0]
    }
    
    public func getChatByResponderOrCreateNew(responder: Profile) -> Chat {
        for chat in chats {
            if chat.firstResponder.id == responder.id || chat.secondResponder.id == responder.id {
                return chat
            }
        }
        let newChat = Chat(id: Int.random(in: 100...10000), firstResponder: getProfileById(id: profileId), secordResponder: responder, messages: [])
        return newChat
    }
}
