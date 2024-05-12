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
    func getAssessmentsForQuestion(_ question: String) async -> [InterviewAssessment]
    func getAnswerAssessment(
        question: String, answer: String, profession: String
    ) async -> Result<InterviewAssessment, CustomError>
}

public final class QuestionsProviderImpl: QuestionsProvider {

    public init(profileProvider: ProfileProvider) {
        self.profileProvider = profileProvider
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

    public func getAssessmentsForQuestion(_ question: String) async -> [InterviewAssessment] {
        let interviewClient = InterviewClient()
        let result = await interviewClient.getDialogAssessments(question: question)
        switch result {
        case .success(let assessments):
            return assessments.map {
                InterviewAssessment(
                    improvement: $0.improvement,
                    completeness: $0.completeness,
                    satisfaction: $0.satisfaction,
                    score: $0.score
                )
            }
        case .failure:
            return []
        }
    }

    public func getMessagesForQuestion(question: String) -> [InterviewMessage] {
        return chats[question] ?? []
    }

    public func getInterviewQuestions(
        for type: Professions
    ) async -> Result<[InterviewQuestion], CustomError> {
        let interviewClient = InterviewClient()
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
        let interviewClient = InterviewClient()
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
        let interviewClient = InterviewClient()
        let userLevelResult = await profileProvider.getUserLevel()
        guard case .success(let level) = userLevelResult else {
            return .failure(.error)
        }
        let result = await interviewClient.getAnsweredQuestion(profession: profession, level: level.rawValue)
        switch result {
        case .success(let questions):
            var assessments: [String: [InterviewAssessment]] = [:]
            for question in questions {
                let assessment = await getAssessmentsForQuestion(question.content)
                assessments[question.content] = assessment
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
