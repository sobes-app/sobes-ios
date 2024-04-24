import Foundation

public struct InterviewChat: Identifiable {

    public let id: Int
    public let messages: [InterviewMessage]

    public init(id: Int, messages: [InterviewMessage]) {
        self.id = id
        self.messages = messages
    }

}
