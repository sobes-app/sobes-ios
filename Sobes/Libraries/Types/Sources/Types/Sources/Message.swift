import SwiftUI

public struct Message: Identifiable, Hashable {

    public let id: Int
    public let author: Int
    public let text: String
    

    public init(id: Int, author: Int, text: String) {
        self.id = id
        self.author = author
        self.text = text
    }
}
