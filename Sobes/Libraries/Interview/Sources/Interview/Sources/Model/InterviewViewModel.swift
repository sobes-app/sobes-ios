import SwiftUI
import Types
import Providers

@MainActor
public protocol InterviewViewModel: ObservableObject {
    var areQuestionsLoading: Bool { get }
    var isAssessmentLoading: Bool { get }
    var messages: [InterviewMessage] { get }
    var questions: [InterviewQuestion] { get }
    var assessment: InterviewAssessment? { get }
    func onViewAppear()
    func fetchUserQuestions(profession: String) async
    func fetchQuestions(for interviewType: InterviewType) async
    func getQuestionsInProgress() -> String
    func getQuestionsWithIdealResult() -> String
    func getMeanQuestionsResult() -> String
    func onUserMessageSent(question: String, text: String)
    func startDialogueForQuestion(question: String, questionId: Int, text: String) async
    func fetchAssessment(question: String, answer: String) async
}

@MainActor
public final class InterviewViewModelImpl: InterviewViewModel {

    @Published public var areQuestionsLoading: Bool = false
    @Published public var isAssessmentLoading: Bool = false
    @Published public var messages: [InterviewMessage] = []
    @Published public var questions: [InterviewQuestion] = []
    @Published public var assessment: InterviewAssessment?

    public init(questionsProvider: QuestionsProvider) {
        self.questionsProvider = questionsProvider
    }

    public func onViewAppear() {
    }

    public func fetchQuestions(for interviewType: InterviewType) async {
        areQuestionsLoading = true
        switch interviewType {
        case .project:
            questions = await questionsProvider.getProjectQuestions()
        case .product:
            questions = await questionsProvider.getProductQuestions()
        case .ba:
            questions = await questionsProvider.getBAQuestions()
        }
        areQuestionsLoading = false
    }

    public func fetchUserQuestions(profession: String) async {
        questions = await questionsProvider.getUserQuestions(profession: profession)
    }

    public func startDialogueForQuestion(question: String, questionId: Int, text: String) async {
        messages = []
        currentQuestionId = questionId
        guard await questionsProvider.areQuestionMessagesEmpty(question: question) else {
            print("huy")
            messages = questionsProvider.getMessagesForQuestion(question: question)
            return
        }
        messages.removeAll()
        let firstMessage = InterviewMessage(id: 0, text: "Привет, я твой интервьюер на сегодняшний день. Давай начнем с такого вопроса...", sender: .gpt(isAssessment: false))
        messages.append(firstMessage)
        questionsProvider.addMessageToInterviewChat(question: question, message: firstMessage)
        let secondMessage = InterviewMessage(id: 1, text: text, sender: .gpt(isAssessment: false))
        messages.append(secondMessage)
        questionsProvider.addMessageToInterviewChat(question: question, message: secondMessage)
    }

    public func onUserMessageSent(question: String, text: String) {
        let messageId = (messages.last?.id ?? -1) + 1
        let message = InterviewMessage(id: messageId, text: text, sender: .user)
        messages.append(message)
        questionsProvider.addMessageToInterviewChat(question: question, message: message)
        let gptMessageId = (messages.last?.id ?? -1) + 1
        let gptMessage = InterviewMessage(id: gptMessageId, text: "Подготовил оценку вашего ответа", sender: .gpt(isAssessment: true))
        messages.append(gptMessage)
        questionsProvider.addMessageToInterviewChat(question: question, message: gptMessage)
    }

    public func fetchAssessment(question: String, answer: String) async {
        isAssessmentLoading = true
        assessment = await questionsProvider.getAnswerAssessment(
            question: question, answer: answer, profession: "Менеджер проекта"
        ) ?? nil
        isAssessmentLoading = false
    }

    public func getQuestionsInProgress() -> String {
        return "\(1)"
    }

    public func getQuestionsWithIdealResult() -> String {
        return "\(8)"
    }

    public func getMeanQuestionsResult() -> String {
        return "\(74.5)"
    }

    private var currentQuestionId: Int = 0
    private let questionsProvider: QuestionsProvider

}
