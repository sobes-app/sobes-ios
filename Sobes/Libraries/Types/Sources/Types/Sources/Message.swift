import SwiftUI

public struct Message: Identifiable, Hashable {

    public let id: Int
    public let isCurrentUser: Bool
    public let text: String
    public var isRead: Bool?
    

    public init(id: Int, isCurrentUser: Bool, text: String, isRead: Bool? = true) {
        self.id = id
        self.isCurrentUser = isCurrentUser
        self.text = text
        self.isRead = isRead
    }
}
