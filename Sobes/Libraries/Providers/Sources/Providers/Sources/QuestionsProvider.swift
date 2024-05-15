import SwiftUI
import Types
import NetworkLayer
import SwiftyKeychainKit

public protocol QuestionsProvider {
    func getInterviewQuestions(
        for type: Professions
    ) async -> Result<[Types.InterviewQuestion], CustomError>
    func getUserQuestions(profession: String) async -> Result<[Types.InterviewQuestion], CustomError>
    func addMessageToInterviewChat(question: String, message: InterviewMessage)
    func areQuestionMessagesEmpty(question: String) async -> Bool
    func getMessagesForQuestion(question: String) async -> Result<[InterviewMessage], CustomError>
    func getAssessmentsForQuestion(_ question: String) async -> Result<[InterviewAssessment], CustomError>
    func getAnswerAssessment(
        question: String, answer: String, profession: String
    ) async -> Result<InterviewAssessment, CustomError>
}

public final class QuestionsProviderImpl: QuestionsProvider {

    public init(profileProvider: ProfileProvider) {
        self.profileProvider = profileProvider
        self.interviewClient = InterviewClient()
    }

    public func areQuestionMessagesEmpty(question: String) async -> Bool {
        let interviewClient = InterviewClient()
        let result = await interviewClient.getDialogAssessments(question: question)
        switch result {
        case .success(let dialog):
            return dialog.isEmpty
        case .failure:
            return true
        }
    }

    public func getAssessmentsForQuestion(_ question: String) async -> Result<[InterviewAssessment], CustomError> {
        let interviewClient = InterviewClient()
        let result = await interviewClient.getDialogAssessments(question: question)
        switch result {
        case .success(let assessments):
            return .success(assessments.map {
                InterviewAssessment(
                    answer: $0.answer,
                    improvement: $0.improvement,
                    completeness: $0.completeness,
                    satisfaction: $0.satisfaction,
                    score: $0.score
                )
            })
        case .failure(let error):
            switch error {
            case .noDataError:
                return .failure(.empty)
            default:
                return .failure(.error)
            }
        }
    }

    public func getMessagesForQuestion(question: String) async -> Result<[InterviewMessage], CustomError> {
        if let savedChat = chats[question] {
            return .success(savedChat)
        } else {
            var chat: [InterviewMessage] = []
            let result = await interviewClient.getDialogAssessments(question: question)
            switch result {
            case .success(let messages):
                chat.append(InterviewMessage(id: 0, text: "Привет, я твой интервьюер на сегодняшний день. Давай начнем с такого вопроса...", sender: .gpt(isAssessment: false)))
                chat.append(InterviewMessage(id: 1, text: question, sender: .gpt(isAssessment: false)))
                for message in messages {
                    var startingId = message.id + 1
                    chat.append(InterviewMessage(id: startingId, text: message.answer, sender: .user))
                    startingId += 1
                    chat.append(
                        InterviewMessage(
                        id: startingId,
                        text: "Подготовил оценку вашего ответа",
                        sender: .gpt(isAssessment: true)
                        )
                    )
                }
                return .success(chat)
            case .failure(let error):
                switch error {
                case .noDataError:
                    return .failure(.empty)
                default:
                    return .failure(.error)
                }
            }
        }
    }

    public func getInterviewQuestions(
        for type: Professions
    ) async -> Result<[InterviewQuestion], CustomError> {
        let userLevelResult = await profileProvider.getUserLevel()
        guard case .success(let level) = userLevelResult else {
            return .failure(.error)
        }
        let result = await interviewClient.generateQuestions(
            profession: type.rawValue,
            level: level.rawValue
        )
        switch result {
        case .success(let questions):
            return .success(questions.enumerated().map { (index, question) in
                InterviewQuestion(id: index, questionType: type, text: question.question)
            })
        case .failure(let error):
            switch error {
            case .httpError(let code):
                if code == 404 {
                    return .failure(.empty)
                }
                return .failure(.error)
            case .noDataError:
                return .failure(.empty)
            case .jsonDecodeError, .jsonEncodeError, .responseError:
                return .failure(.error)
            }
        }
    }

    public func getAnswerAssessment(
        question: String, answer: String, profession: String
    ) async -> Result<InterviewAssessment, CustomError> {
        let result = await interviewClient.getAssessment(question: question, answer: answer, profession: profession)
        switch result {
        case .success(let assessment):
            return .success(InterviewAssessment(
                answer: assessment.answer,
                improvement: assessment.improvement,
                completeness: assessment.completeness,
                satisfaction: assessment.satisfaction,
                score: assessment.score
            ))
        case .failure(let error):
            switch error {
            case .httpError(let code):
                if code == 404 {
                    return .failure(.empty)
                }
                return .failure(.error)
            case .noDataError:
                return .failure(.empty)
            case .jsonDecodeError, .jsonEncodeError, .responseError:
                return .failure(.error)
            }
        }
    }

    public func getUserQuestions(profession: String) async -> Result<[Types.InterviewQuestion], CustomError> {
        let userLevelResult = await profileProvider.getUserLevel()
        guard case .success(let level) = userLevelResult else {
            return .failure(.error)
        }
        let result = await interviewClient.getAnsweredQuestion(profession: profession, level: level.rawValue)
        switch result {
        case .success(let questions):
            var assessments: [String: [InterviewAssessment]] = [:]
            for question in questions {
                let assessmentsResult = await getAssessmentsForQuestion(question.content)
                switch assessmentsResult {
                case .success(let assess):
                    assessments[question.content] = assess
                case .failure(let error):
                    switch error {
                    case .empty:
                        return .failure(.empty)
                    case .error:
                        return .failure(.error)
                    }
                }
            }

            return .success(questions.map {
                return InterviewQuestion(
                    id: $0.id,
                    questionType: Professions(rawValue: $0.profession.profession) ?? .no,
                    text: $0.content,
                    result: Int((assessments[$0.content]?.sum() ?? 0) / (assessments[$0.content]?.count ?? 1))
                )
            })
        case .failure(let error):
            switch error {
            case .httpError(let code):
                if code == 404 {
                    return .failure(.empty)
                }
                return .failure(.error)
            case .noDataError:
                return .failure(.empty)
            case .jsonDecodeError, .jsonEncodeError, .responseError:
                return .failure(.error)
            }
        }
    }

    public func addMessageToInterviewChat(question: String, message: InterviewMessage) {
        if chats[question] == nil {
            chats[question] = []
        }
        chats[question]?.append(message)
    }

    private let keychain: Keychain = Keychain(service: "com.swifty.keychain")
    private let accessTokenKey = KeychainKey<String>(key: "accessToken")
    private let tokenType = KeychainKey<String>(key: "tokenType")
    private var chats: [String : [InterviewMessage]] = [:]
    private let profileProvider: ProfileProvider
    private let interviewClient: InterviewClient

}

extension Array where Element == InterviewAssessment {
    public func sum() -> Int {
        var sum = 0
        for x in 0..<self.count{
            sum += Int(self[x].score)
        }

        return sum
    }
}
