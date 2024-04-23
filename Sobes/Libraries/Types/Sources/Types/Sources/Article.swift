import SwiftUI

public struct Article: Identifiable, Equatable, Hashable {

    public let id: Int
    public let logo: String?
    public let author: String
    public let text: String
    public let url: String

    public init(id: Int, logo: String?, author: String, text: String, url: String) {
        self.id = id
        self.logo = logo
        self.author = author
        self.text = text
        self.url = url
    }
    
}
