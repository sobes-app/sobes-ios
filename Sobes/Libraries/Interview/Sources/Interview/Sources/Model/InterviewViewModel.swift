import SwiftUI
import Types
import Providers

@MainActor
public protocol InterviewViewModel: ObservableObject {
    var messages: [InterviewMessage] { get }
    var questions: [InterviewQuestion] { get }
    var professions: [Professions] { get }
    var assessment: InterviewAssessment? { get }
    var statistics: InterviewStatistics? { get }
    var isError: Bool { get }
    var isLoading: Bool { get }
    var isStatisticsLoading: Bool { get }

    func onViewAppear() async
    func fetchUserQuestions(profession: String) async
    func fetchQuestions(for interviewType: Professions) async
    func fetchUserStatistics(profession: String)
    func getPublicStatistics(type: PublicStatisticsField, profession: Professions) -> Int
    func onUserMessageSent(question: String, text: String)
    func startDialogueForQuestion(question: String, questionId: Int, text: String) async
    func fetchAssessment(question: String, answer: String) async
}

@MainActor
public final class InterviewViewModelImpl: InterviewViewModel {

    @Published public var isLoading: Bool = false
    @Published public var isStatisticsLoading: Bool = false
    @Published public var isError: Bool = false
    @Published public var messages: [InterviewMessage] = []
    @Published public var questions: [InterviewQuestion] = []
    @Published public var professions: [Professions] = []
    @Published public var assessment: InterviewAssessment?
    @Published public var statistics: InterviewStatistics?

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
            case .error:
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
            switch error {
            case .empty:
                self.questions = []
            case .error:
                isError = true
            }
        }
    }

    public func fetchUserQuestions(profession: String) async {
        isError = false
        isLoading = true
        currentChatProfession = Professions(rawValue: profession)
        let result = await questionsProvider.getUserQuestions(profession: profession)
        switch result {
        case .success(let questions):
            isLoading = false
            self.questions = questions
        case .failure(let error):
            isLoading = false
            switch error {
            case .empty:
                self.questions = []
            case .error:
                isError = true
            }
        }
    }

    public func fetchUserStatistics(profession: String) {
        currentChatProfession = Professions(rawValue: profession)
        guard !questions.isEmpty else { return }

        if questions.count != getPublicStatistics(type: .inWork, profession: currentChatProfession ?? .no) {
            setValue(predicate: PublicStatisticsField.inWork.rawValue, value: questions.count)

            var assessmentsForProfession: [Int] = []
            for question in questions {
                assessmentsForProfession.append(Int(question.result ?? 0))
                if question.result ?? 0 > 95 {
                    let idealQuestions = getPublicStatistics(type: .ideal, profession: currentChatProfession ?? .no) + 1
                    setValue(predicate: PublicStatisticsField.ideal.rawValue, value: idealQuestions)
                }
            }

            setValue(predicate: PrivateStatisticsField.allAssessments.rawValue, value: assessmentsForProfession)

            let meanRes = assessmentsForProfession.sum() / questions.count
            setValue(predicate: PublicStatisticsField.meanResult.rawValue, value: Int(meanRes))
        }

        statistics = InterviewStatistics(
            questionsInWork: getPublicStatistics(type: .inWork, profession: currentChatProfession ?? .no),
            questionsIdealResult: getPublicStatistics(type: .ideal, profession: currentChatProfession ?? .no),
            questionsMeanResult: getPublicStatistics(type: .meanResult, profession: currentChatProfession ?? .no)
        )
    }

    public func startDialogueForQuestion(question: String, questionId: Int, text: String) async {
        isLoading = true
        isError = false
        messages = []
        guard await questionsProvider.areQuestionMessagesEmpty(question: question) else {
            let result = await questionsProvider.getMessagesForQuestion(question: question)
            switch result {
            case .success(let chat):
                isLoading = false
                messages = chat
            case .failure(let error):
                isLoading = false
                switch error {
                case .empty:
                    messages = []
                case .error:
                    isError = true
                }
            }
            return
        }
        isLoading = false
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

        // If this dialogue is just started, update statistics
        if messageId == 2 {
            updateStaticticsValues()
        }
    }

    public func fetchAssessment(question: String, answer: String) async {
        isError = false
        isLoading = true
        if let assessment = assessments[answer] {
            isLoading = false
            self.assessment = assessment
            return
        } else if let assessment = await getAssessmentByQuestion(question: question, answer: answer) {
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
            updateStatisticsValues(assessment: assessment)
        case .failure(let error):
            isLoading = false
            switch error {
            case .empty, .error:
                isError = true
            }
        }
    }

    private func getAssessmentByQuestion(question: String, answer: String) async -> InterviewAssessment? {
        let result = await questionsProvider.getAssessmentsForQuestion(question)
        switch result {
        case .success(let chat):
            isLoading = false
            return chat.first(where: {
                $0.answer == answer
            }) ?? nil
        case .failure(let error):
            isLoading = false
            switch error {
            case .empty:
                return nil
            case .error:
                isError = true
                return nil
            }
        }
    }

    public func getPublicStatistics(type: PublicStatisticsField, profession: Professions) -> Int {
        switch profession {
        case .no:
            return 0
        case .product:
            return UserDefaults.standard.integer(forKey: type.rawValue + "Product")
        case .project:
            return UserDefaults.standard.integer(forKey: type.rawValue + "Project")
        case .analyst:
            return UserDefaults.standard.integer(forKey: type.rawValue + "BA")
        }
    }

    private func updateStatisticsValues(assessment: InterviewAssessment) {
        guard let currentChatProfession else { return }
        if assessment.completeness > 95 && assessment.satisfaction > 95 {
            let idealStored = getPublicStatistics(type: .ideal, profession: currentChatProfession) + 1
            let inWorkStored = getPublicStatistics(type: .inWork, profession: currentChatProfession) - 1

            let predicate = PublicStatisticsField.ideal.rawValue
            setValue(predicate: predicate, value: idealStored)

            if inWorkStored >= 0 {
                let predicate = PublicStatisticsField.inWork.rawValue
                setValue(predicate: predicate, value: inWorkStored)
            }
        }

        var allAssessments = getAllAssessments(profession: currentChatProfession)
        allAssessments.append(Int(assessment.score))
        var predicate = PrivateStatisticsField.allAssessments.rawValue
        setValue(predicate: predicate, value: allAssessments)

        let newMeanRes = getAllAssessments(profession: currentChatProfession).sum() / getAllAssessments(profession: currentChatProfession).count
        predicate = PublicStatisticsField.meanResult.rawValue
        setValue(predicate: predicate, value: newMeanRes)
    }

    private func getAllAssessments(profession: Professions) -> [Int] {
        let predicate = PrivateStatisticsField.allAssessments.rawValue
        switch profession {
        case .no: return []
        case .product: return UserDefaults.standard.array(forKey: predicate + "Product") as? [Int] ?? []
        case .project: return UserDefaults.standard.array(forKey: predicate + "Project") as? [Int] ?? []
        case .analyst: return UserDefaults.standard.array(forKey: predicate + "BA") as? [Int] ?? []
        }
    }

    private func getAllQuestionsAnswered(profession: Professions) -> Int {
        let predicate = PrivateStatisticsField.allQuestions.rawValue
        switch profession {
        case .no: return 0
        case .product: return UserDefaults.standard.integer(forKey: predicate + "Product")
        case .project: return UserDefaults.standard.integer(forKey: predicate + "Project")
        case .analyst: return UserDefaults.standard.integer(forKey: predicate + "BA")
        }
    }

    private func updateStaticticsValues() {
        guard let currentChatProfession else { return }
        let allQuestionsAnswered = getAllQuestionsAnswered(profession: currentChatProfession) + 1
        var predicate = PrivateStatisticsField.allQuestions.rawValue
        setValue(predicate: predicate, value: allQuestionsAnswered)

        let inProgressQuestions = getPublicStatistics(type: .inWork, profession: currentChatProfession) + 1
        predicate = PublicStatisticsField.inWork.rawValue
        setValue(predicate: predicate, value: inProgressQuestions)
    }

    private func setValue(predicate: String, value: Int) {
        guard let currentChatProfession else { return }
        switch currentChatProfession {
        case .no:
            break
        case .product:
            UserDefaults.standard.set(value, forKey: predicate + "Product")
        case .project:
            UserDefaults.standard.set(value, forKey: predicate + "Project")
        case .analyst:
            UserDefaults.standard.set(value, forKey: predicate + "BA")
        }
    }

    private func setValue(predicate: String, value: [Int]) {
        guard let currentChatProfession else { return }
        switch currentChatProfession {
        case .no:
            break
        case .product:
            UserDefaults.standard.set(value, forKey: predicate + "Product")
        case .project:
            UserDefaults.standard.set(value, forKey: predicate + "Project")
        case .analyst:
            UserDefaults.standard.set(value, forKey: predicate + "BA")
        }
    }

    private let questionsProvider: QuestionsProvider
    private let profileProvider: ProfileProvider
    private var currentChatProfession: Professions?
    private var assessments: [String : InterviewAssessment] = [:]

}

public enum PublicStatisticsField: String {
    case inWork = "questionsInWork"
    case ideal = "questionsIdealResult"
    case meanResult = "questionsMeanResult"
}

public enum PrivateStatisticsField: String {
    case allQuestions = "questionsAll"
    case allAssessments = "questionsAllAssessments"
}

extension Array where Element == Int {
    public func sum() -> Int {
        var sum = 0
        for x in 0..<self.count{
           sum += self[x]
        }

        return sum
    }
}
