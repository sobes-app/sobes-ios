import SwiftUI

public struct Tip: Identifiable, Equatable, Hashable {

    public let id: Int
    public let logo: Image
    public let companyName: String
    public let author: String
    public let role: String
    public let text: String

    public init(id: Int, logo: Image, companyName: String, author: String, role: String, text: String) {
        self.id = id
        self.logo = logo
        self.companyName = companyName
        self.author = author
        self.role = role
        self.text = text
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}
