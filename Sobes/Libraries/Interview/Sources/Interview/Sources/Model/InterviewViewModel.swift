import SwiftUI
import Types
import Providers

@MainActor
public protocol InterviewViewModel: ObservableObject {
    var messages: [InterviewMessage] { get }
    var questions: [InterviewQuestion] { get }
    var professions: [Professions] { get }
    var assessment: InterviewAssessment? { get }
    var isError: Bool { get }
    var isLoading: Bool { get }

    func onViewAppear() async
    func fetchUserQuestions(profession: String) async
    func fetchQuestions(for interviewType: Professions) async
    func getQuestionsInProgress() -> String
    func getQuestionsWithIdealResult() -> String
    func getMeanQuestionsResult() -> String
    func onUserMessageSent(question: String, text: String)
    func startDialogueForQuestion(question: String, questionId: Int, text: String) async
    func fetchAssessment(question: String, answer: String) async
}

@MainActor
public final class InterviewViewModelImpl: InterviewViewModel {

    @Published public var isLoading: Bool = false
    @Published public var isError: Bool = false
    @Published public var messages: [InterviewMessage] = []
    @Published public var questions: [InterviewQuestion] = []
    @Published public var professions: [Professions] = []
    @Published public var assessment: InterviewAssessment?

    public init(questionsProvider: QuestionsProvider, profileProvider: ProfileProvider) {
        self.questionsProvider = questionsProvider
        self.profileProvider = profileProvider
    }

    @MainActor
    public func onViewAppear() async {
        isError = false
        isLoading = true
        let professionsRequest = await profileProvider.getUserProfessions()
        switch professionsRequest {
        case .success(let professions):
            isLoading = false
            self.professions = professions
        case .failure(let error):
            isLoading = false
            switch error {
            case .empty:
                self.professions = []
            case .error, .unauthorized:
                isError = true
            }
        }
    }

    public func fetchQuestions(for interviewType: Professions) async {
        isError = false
        isLoading = true
        currentChatProfession = interviewType
        let result = await questionsProvider.getInterviewQuestions(for: interviewType)
        switch result {
        case .success(let interviewQuestions):
            isLoading = false
            self.questions = interviewQuestions
        case .failure(let error):
            isLoading = false
            if error == .empty {
                self.questions = []
            } else {
                isError = true
            }
        }
    }

    public func fetchUserQuestions(profession: String) async {
        isError = false
        isLoading = true
        let result = await questionsProvider.getUserQuestions(profession: profession)
        switch result {
        case .success(let questions):
            isLoading = false
            self.questions = questions
        case .failure(let error):
            isLoading = false
            if error == .empty {
                self.questions = []
            } else {
                isError = true
            }
        }
    }

    public func startDialogueForQuestion(question: String, questionId: Int, text: String) async {
        messages = []
        currentQuestionId = questionId
        guard await questionsProvider.areQuestionMessagesEmpty(question: question) else {
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
        isError = false
        isLoading = true
        if let assessment = assessments[answer] {
            isLoading = false
            self.assessment = assessment
            return
        }
        let result = await questionsProvider.getAnswerAssessment(
            question: question,
            answer: answer,
            profession: currentChatProfession?.rawValue ?? ""
        )
        switch result {
        case .success(let assessment):
            isError = false
            isLoading = false
            self.assessment = assessment
            assessments[answer] = assessment
        case .failure:
            isLoading = false
            isError = true
        }
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
    private let profileProvider: ProfileProvider
    private var currentChatProfession: Professions?
    private var assessments: [String : InterviewAssessment] = [:]

}
