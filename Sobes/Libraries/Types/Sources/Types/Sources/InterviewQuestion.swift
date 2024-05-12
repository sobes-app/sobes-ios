import Foundation

public struct InterviewQuestion: Identifiable {

    public let id: Int
    public let questionType: Professions
    public let text: String
    public let result: Int?
    public var messages: [InterviewMessage]

    public init(id: Int, questionType: Professions, text: String, result: Int? = nil, messages: [InterviewMessage] = []) {
        self.id = id
        self.questionType = questionType
        self.text = text
        self.result = result
        self.messages = messages
    }
    
}
