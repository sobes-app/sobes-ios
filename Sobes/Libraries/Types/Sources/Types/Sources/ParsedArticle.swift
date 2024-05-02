import SwiftUI

public struct ParsedArticle: Identifiable, Equatable, Hashable {

    public let id: Int
    public let source: String?
    public let tags: [String]
    public let logo: String?
    public let author: String?
    public let heading: String?
    public let datePublished: String?
    public let bodyText: String?
    public let url: String

    public init(id: Int, source: String?, tags: [String], logo: String?, author: String?, heading: String?, datePublished: String?, bodyText: String?, url: String) {
        self.id = id
        self.source = source
        self.tags = tags
        self.logo = logo
        self.author = author
        self.heading = heading
        self.datePublished = datePublished
        self.bodyText = bodyText
        self.url = url
    }

}
