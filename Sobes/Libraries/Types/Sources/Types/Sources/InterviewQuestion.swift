import Foundation

public struct InterviewQuestion: Identifiable {

    public enum QuestionType: String {
        case project = "Менеджер проекта"
        case product = "Менеджер продукта"
        case ba = "Бизнес-аналитик"
    }

    public let id: Int
    public let questionType: QuestionType
    public let text: String
    public let result: Double?
    public var messages: [InterviewMessage]

    public init(id: Int, questionType: QuestionType, text: String, result: Double? = nil, messages: [InterviewMessage] = []) {
        self.id = id
        self.questionType = questionType
        self.text = text
        self.result = result
        self.messages = messages
    }
    
}
