import SwiftUI
import Types
import Providers

@MainActor
public protocol InterviewViewModel: ObservableObject {
    var messages: [InterviewMessage] { get }
    var questions: [InterviewQuestion] { get }
    func onViewAppear()
    func fetchUserQuestions()
    func fetchQuestions(for interviewType: InterviewType)
    func getQuestionsInProgress() -> String
    func getQuestionsWithIdealResult() -> String
    func getMeanQuestionsResult() -> String
    func onUserMessageSent(text: String)
    func startDialogueForQuestion(questionId: Int, text: String)
}

@MainActor
public final class InterviewViewModelImpl: InterviewViewModel {

    @Published public var messages: [InterviewMessage] = []
    @Published public var questions: [InterviewQuestion] = []

    public init(questionsProvider: QuestionsProvider) {
        self.questionsProvider = questionsProvider
    }

    public func onViewAppear() {
    }

    public func fetchQuestions(for interviewType: InterviewType) {
        switch interviewType {
        case .project:
            questions = Array(questionsProvider.getProjectQuestions().shuffled()[0..<3])
        case .product:
            questions = Array(questionsProvider.getProductQuestions().shuffled()[0..<3])
        case .ba:
            questions = Array(questionsProvider.getBAQuestions().shuffled()[0..<3])
        }
    }

    public func fetchUserQuestions() {
        questions = questionsProvider.getUserQuestions()
    }

    public func startDialogueForQuestion(questionId: Int,text: String) {
        messages = []
        currentQuestionId = questionId
        guard questionsProvider.areQuestionMessagesEmpty(id: questionId) else {
            messages.append(contentsOf: questionsProvider.getMessagesForQuestion(id: questionId))
            return
        }
        messages.removeAll()
        let firstMessage = InterviewMessage(id: 0, text: "Привет, я твой интервьюер на сегодняшний день. Давай начнем с такого вопроса...", sender: .gpt(isAssessment: false))
        messages.append(firstMessage)
        questionsProvider.addMessageToInterviewChat(questionId: questionId, message: firstMessage)
        let secondMessage = InterviewMessage(id: 1, text: text, sender: .gpt(isAssessment: false))
        messages.append(secondMessage)
        questionsProvider.addMessageToInterviewChat(questionId: questionId, message: secondMessage)
    }

    public func onUserMessageSent(text: String) {
        let messageId = (messages.last?.id ?? -1) + 1
        let message = InterviewMessage(id: messageId, text: text, sender: .user)
        messages.append(message)
        questionsProvider.addMessageToInterviewChat(questionId: currentQuestionId, message: message)
        let gptMessageId = (messages.last?.id ?? -1) + 1
        let gptMessage = InterviewMessage(id: gptMessageId, text: "Я пока не умею оценивать твои ответы, но совсем скоро научусь!", sender: .gpt(isAssessment: false))
        messages.append(gptMessage)
        questionsProvider.addMessageToInterviewChat(questionId: currentQuestionId, message: gptMessage)
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
