import Foundation

public struct InterviewMessage: Identifiable {

    public enum Sender {
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
