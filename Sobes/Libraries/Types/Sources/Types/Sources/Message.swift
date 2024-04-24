import SwiftUI

public struct Message: Identifiable, Hashable {

    public let id: Int
    public let author: Int
    public let text: String
    public var isWritten: Bool?
    

    public init(id: Int, author: Int, text: String, isWritten: Bool? = true) {
        self.id = id
        self.author = author
        self.text = text
        self.isWritten = isWritten
    }
}
