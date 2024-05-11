import SwiftUI
import NetworkLayer

public enum Companies: String, CaseIterable {
    case no = ""
    case tinkoff = "Тинькофф"
    case yandex = "Яндекс"
    case other = "Другое"
}

public enum Professions: String, CaseIterable {
    case no = ""
    case product = "Менеджер продукта"
    case project = "Менеджер проекта"
    case analyst = "Бизнес-аналитик"
}

public enum Levels: String, CaseIterable {
    case no = ""
    case inter = "Стажировка"
    case jun = "Jun/Jun+"
    case mid = "Middle/Middle+"
    case sen = "Senior"
}

public struct Profile: Identifiable, Hashable {
    
    public let id: Int
    public var name: String
    public let email: String
    public var professions: [Professions]
    public var companies: [Companies]
    public var level: Levels
    public var mode: ApplicationMode

    public init() {
        self.id = 0
        self.name = "Example"
        self.professions = [.no]
        self.companies = [.no]
        self.level = .no
        self.email = "example@ya.ru"
        self.mode = .user
    }
    
    public init(signUpResponse: SignUpResponse) {
        self.id = signUpResponse.id
        self.name = signUpResponse.username
        self.email = signUpResponse.email
        self.professions = []
        self.companies = []
        self.level = Levels.no
        self.mode = email == "barbashina015@mail.ru" ? .admin : .user
    }
    
    public init(profileResponse: ProfileResponse) {
        self.id = profileResponse.id
        self.name = profileResponse.username ?? ""
        self.email = profileResponse.email
        self.professions = Profile.setProfessions(array: Array(profileResponse.professions ?? []))
        self.companies = Profile.setCompanies(array: Array(profileResponse.companies ?? []))
        self.level = Levels(rawValue: profileResponse.level ?? "") ?? .no
        self.mode = email == "barbashina015@mail.ru" ? .admin : .user
    }
    
    public static func createStringOfCompanies(of profile: Profile) -> [String] {
        return profile.companies.map { $0.rawValue }
    }
    
    public static func createStringOfProfessions(of profile: Profile) -> [String] {
        return profile.professions.map { $0.rawValue }
    }
    
    public static func stringArrayComp(of comp: [Companies]) -> [String] {
        return comp.map { $0.rawValue }
    }
    
    public static func stringArrayProf(of prof: [Professions]) -> [String] {
        return prof.map { $0.rawValue }
    }
    
    public static func setProfessions(array: [String]) -> [Professions] {
        return array.map { Professions(rawValue: $0) ?? .no }
    }
    
    public static func setCompanies(array: [String]) -> [Companies] {
        return array.map { Companies(rawValue: $0) ?? .no }
    }
}
