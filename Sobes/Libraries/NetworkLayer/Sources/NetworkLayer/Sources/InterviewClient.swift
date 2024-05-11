import Foundation

public struct MessageRequest: Encodable {
    public let profession: String
    public let level: String
}

public struct AnswerRequest: Encodable {
    public let question: String
    public let answer: String
    public let profession: String
}

public struct AnswerResponse: Decodable {
    public let id: Int
    public let improvement: String
    public let completeness: Int
    public let satisfaction: Int
    public let score: Double
}

public struct QuestionResponse: Decodable {
    public let id: Int
    public let content: String
    public let profession: Profession
}

public struct DialogRequest: Encodable {
    public let question: String
}

public struct Profession: Decodable {
    public let id: Int
    public let profession: String
}

public struct GeneratedQuestionsResponse: Decodable {
    public let question: String
}

public final class InterviewClient {

    public init() {
        self.netLayer = NetworkLayer()
    }

    /// Get all questions that user has answered to specified by profession.
    ///
    /// - Parameters:
    ///     - profession: Profession of the user.
    ///     - level: Level of the user.
    ///
    /// - Returns: Array of questions user has answered to.
    public func getAnsweredQuestion(profession: String, level: String) async -> Result<[QuestionResponse], ClientError> {
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(
                method: "POST",
                urlPattern: "/user/interview/question",
                body: MessageRequest(profession: profession, level: level)
            ) { result in
                continuation.resume(returning: result)
            }
        }
    }

    /// Generate five questions for specified profession and level.
    ///
    /// - Parameters:
    ///     - profession: Profession of the user.
    ///     - level: Level of the user.
    ///
    /// - Returns: Array of five question generated for specified profession and level of proficiency.
    public func generateQuestions(profession: String, level: String) async -> Result<[GeneratedQuestionsResponse], ClientError> {
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(
                method: "POST",
                urlPattern: "/user/interview/generate",
                body: MessageRequest(profession: profession, level: level)
            ) { result in
                continuation.resume(returning: result)
            }
        }
    }

    /// Get array of answer asessments for specific question.
    ///
    /// - Parameters:
    ///     - question: Question that has dialog.
    ///
    /// - Returns: Array of all messages-assessments from LLM for the specified question.
    public func getDialogAssessments(question: String) async -> Result<[AnswerResponse], ClientError> {
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(
                method: "POST",
                urlPattern: "/user/interview/dialog",
                body: DialogRequest(question: question)
            ) { result in
                continuation.resume(returning: result)
            }
        }
    }

    /// Get array of answer asessments for specific question.
    ///
    /// - Parameters:
    ///     - question: Question of current dialog.
    ///     - answer: Answer user provided.
    ///     - profession: Profession of the interview.
    ///
    /// - Returns: Assessment for the provided answer.
    public func getAssessment(
        question: String, answer: String, profession: String
    ) async -> Result<AnswerResponse, ClientError> {
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(
                method: "POST",
                urlPattern: "/user/interview/answer",
                body: AnswerRequest(question: question, answer: answer, profession: profession)
            ) { result in
                continuation.resume(returning: result)
            }
        }
    }

    private let netLayer: NetworkLayer
}
