import SwiftUI

public struct Article: Identifiable, Equatable, Hashable {

    public let id: Int
    public let logo: Image
    public let companyName: String
    public let author: String
    public let text: String

    public init(id: Int, logo: Image, companyName: String, author: String, text: String) {
        self.id = id
        self.logo = logo
        self.companyName = companyName
        self.author = author
        self.text = text
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
