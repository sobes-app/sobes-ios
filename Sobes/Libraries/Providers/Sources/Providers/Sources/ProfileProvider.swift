import Foundation
import Types

public protocol ProfileProvider {
    func getProfiles() -> [Types.Profile]
    func getCurrentUser() -> Types.Profile
    func updateProfileInfo(id: Int, companies: [Companies], level: Levels, professions: [Professions])
}

public final class ProfileProviderImpl: ProfileProvider {

    public init() { }

    public func getProfiles() -> [Types.Profile] {
        return profiles
    }

    public func getCurrentUser() -> Types.Profile {
        return profiles[0]
    }

    private var profiles: [Types.Profile] = [
        Profile(id: 0, name: "Алиса Вышегородцева", professions: [], companies: [], level: .no),
        Profile(id: 1, name: "Яна Барбашина", professions: [.product], companies: [.tinkoff], level: .inter),
        Profile(id: 2, name: "Даяна Тасбауова", professions: [.project, .analyst], companies: [.yandex, .other], level: .jun),
        Profile(id: 3, name: "Колобок", professions: [.product, .project, .analyst], companies: [], level: .sen),
        Profile(id: 4, name: "Лисица", professions: [.product, .project], companies: [.tinkoff,.other], level: .mid)
    ]
    
    public func updateProfileInfo(id: Int, companies: [Companies], level: Levels, professions: [Professions]) {
        profiles[id].level = level
        profiles[id].professions = professions
        profiles[id].companies = companies
    }
}
