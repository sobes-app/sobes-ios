import SwiftUI
import NetworkLayer

public struct Message: Hashable {

    public let messageId: Int
    public let isCurrentUser: Bool
    public let chatId: Int
    public let text: String
    public var isRead: Bool?
    public var date: Date
    

    public init(isCurrentUser: Bool, text: String, isRead: Bool? = true, chatId: Int, date: Date, messageId: Int) {
        self.isCurrentUser = isCurrentUser
        self.text = text
        self.isRead = isRead
        self.chatId = chatId
        self.date = date
        self.messageId = messageId
    }
    
    public init(messageResponse: MessagesResponse, isCurrent: Bool) {
        self.isCurrentUser = isCurrent
        self.text = messageResponse.text
        self.isRead = messageResponse.isRead
        self.chatId = messageResponse.chatId
        self.messageId = messageResponse.messageId

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = dateFormatter.date(from: messageResponse.date) {
            self.date = date
        } else {
            self.date = Date()
        }
    }
}
