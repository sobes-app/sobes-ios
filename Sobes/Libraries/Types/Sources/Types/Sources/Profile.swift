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
    
    public init() {
        self.id = 0
        self.name = "Example"
        self.professions = [.no]
        self.companies = [.no]
        self.level = .no
        self.email = "example@ya.ru"
    }
    
    public init(signUpResponse: SignUpResponse) {
        self.id = signUpResponse.id
        self.name = signUpResponse.username
        self.email = signUpResponse.email
        self.professions = []
        self.companies = []
        self.level = Levels.no
    }
    
    public init(profileResponse: ProfileResponse) {
        self.id = profileResponse.id
        self.name = profileResponse.username ?? ""
        self.email = profileResponse.email
        self.professions = Profile.setProfessions(array: Array(profileResponse.professions ?? []))
        self.companies = Profile.setCompanies(array: Array(profileResponse.companies ?? []))
        self.level = Levels(rawValue: profileResponse.level ?? "") ?? .no
    }
    
    public static func createStringOfCompanies(of profile: Profile) -> [String] {
        var array: [String] = []
        for company in profile.companies {
            array.append(company.rawValue)
        }
        return array
    }
    
    public static func createStringOfProfessions(of profile: Profile) -> [String] {
        var array: [String] = []
        for profession in profile.professions {
            array.append(profession.rawValue)
        }
        return array
    }
    
    public static func stringArrayComp(of comp: [Companies]) -> [String] {
        var array: [String] = []
        for company in comp {
            array.append(company.rawValue)
        }
        return array
    }
    
    public static func stringArrayProf(of prof: [Professions]) -> [String] {
        var array: [String] = []
        for profession in prof {
            array.append(profession.rawValue)
        }
        return array
    }
    
    public static func setProfessions(array: [String]) -> [Professions]{
        var profArray: [Professions] = []
        for i in array {
            profArray.append(Professions(rawValue: i) ?? .no)
        }
        return profArray
    }
    
    public static func setCompanies(array: [String]) -> [Companies] {
        var compArray: [Companies] = []
        for i in array {
            compArray.append(Companies(rawValue: i) ?? .no)
        }
        return compArray
    }
}
