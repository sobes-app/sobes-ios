import Foundation

public struct InterviewMessage: Identifiable, Equatable {

    public enum Sender: Equatable {
        case user
        case gpt(isAssessment: Bool)
    }

    public let id: Int
    public let text: String
    public let sender: Sender

    public init(id: Int, text: String, sender: Sender) {
        self.id = id
        self.text = text
        self.sender = sender
    }

}
