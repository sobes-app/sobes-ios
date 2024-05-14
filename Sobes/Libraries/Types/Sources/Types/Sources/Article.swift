import SwiftUI

public struct Article: Equatable, Hashable {

    public let logo: String?
    public let author: String?
    public let text: String?
    public let url: String

    public init(logo: String?, author: String?, text: String?, url: String) {
        self.logo = logo
        self.author = author
        self.text = text
        self.url = url
    }

}
