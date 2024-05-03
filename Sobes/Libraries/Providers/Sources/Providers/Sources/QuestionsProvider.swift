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
    func getMessagesForQuestion(question: String) -> [InterviewMessage]
    func getAnswerAssessment(
        question: String, answer: String, profession: String
    ) async -> Result<InterviewAssessment, CustomError>
}

public final class QuestionsProviderImpl: QuestionsProvider {

    public init(profileProvider: ProfileProvider) {
        self.profileProvider = profileProvider
    }

    public func areQuestionMessagesEmpty(question: String) async -> Bool {
        let interviewClient = InterviewClient(token: try? self.keychain.get(accessTokenKey))
        let result = await interviewClient.getDialogAssessments(question: question)
        switch result {
        case .success(let dialog):
            return dialog.isEmpty
        case .failure:
            return true
        }
    }

    public func getMessagesForQuestion(question: String) -> [InterviewMessage] {
        return chats[question] ?? []
    }

    public func getInterviewQuestions(
        for type: Professions
    ) async -> Result<[Types.InterviewQuestion], CustomError> {
        let interviewClient = InterviewClient(token: try? self.keychain.get(accessTokenKey))
        let result = await interviewClient.generateQuestions(
            profession: type.rawValue,
            level: profileProvider.getUserLevel().rawValue
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
        let interviewClient = InterviewClient(token: try? self.keychain.get(accessTokenKey))
        let result = await interviewClient.getAssessment(question: question, answer: answer, profession: profession)
        switch result {
        case .success(let assessment):
            return .success(InterviewAssessment(
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
        let interviewClient = InterviewClient(token: try? self.keychain.get(accessTokenKey))
        let result = await interviewClient.getAnsweredQuestion(profession: profession, level: "Junior")
        switch result {
        case .success(let questions):
            return .success(questions.map {
                InterviewQuestion(
                    id: $0.id,
                    questionType: Professions(rawValue: $0.profession.profession) ?? .project,
                    text: $0.content
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
    private var chats: [String : [InterviewMessage]] = [:]
    private let profileProvider: ProfileProvider

}
