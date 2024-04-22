import Foundation

public struct InterviewMessage: Identifiable {

    public enum Sender {
        case user
        case gpt(isAssessment: Bool)
    }

    public let id: Int
    public let text: String
    public let sender: Sender

}
