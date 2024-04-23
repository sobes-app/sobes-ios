import SwiftUI

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
    public var professions: [Professions]
    public var companies: [Companies]
    public var level: Levels

    public init(id: Int, name: String, professions: [Professions], companies: [Companies], level: Levels) {
        self.id = id
        self.name = name
        self.professions = professions
        self.companies = companies
        self.level = level
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

}
