import SwiftUI

public struct Tip: Identifiable, Equatable, Hashable {

    public enum Company: String {
        case tinkoff = "Тинькофф"
        case yandex = "Яндекс"
    }

    public let id: Int
    public let logo: Image
    public let company: Company
    public let author: String
    public let role: String
    public let text: String

    public init(id: Int, logo: Image, company: Company, author: String, role: String, text: String) {
        self.id = id
        self.logo = logo
        self.company = company
        self.author = author
        self.role = role
        self.text = text
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}
