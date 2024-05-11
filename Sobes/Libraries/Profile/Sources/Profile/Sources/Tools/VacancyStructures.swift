import Foundation
import Types
import Providers
import SwiftUI

struct Vacancy: Codable {
    let items: [Item]
    let pages: Int
}

public struct Item: Codable, Identifiable {
    public let id: String
    let name: String
    let area: Area
    let employer: Employer
    let salary: Salary?
    let alternate_url: String?
    let experience: Experience
    
    init(id: String, name: String, area: Area, employer: Employer, salary: Salary?, alternate_url: String?, experience: Experience) {
        self.id = id
        self.name = name
        self.area = area
        self.employer = employer
        self.salary = salary
        self.alternate_url = alternate_url
        self.experience = experience
    }
}

struct Experience: Codable {
    let name: String
}

struct Area: Codable {
    let name: String
}

struct Employer: Codable {
    let id: String
    let name: String
    let logo_urls: [String: String]?
}

struct LogoURL: Codable {
    var original: String
}

struct Salary: Codable {
    let from: Int?
    let to: Int?
    let currency: String?
}

struct EmployerSearch: Codable {
    let items: [Employer]
}
