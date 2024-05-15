import Foundation

public struct InterviewAssessment {

    public let answer: String
    public let improvement: String
    public let completeness: Int
    public let satisfaction: Int
    public let score: Double

    public init(answer: String, improvement: String, completeness: Int, satisfaction: Int, score: Double) {
        self.answer = answer
        self.improvement = improvement
        self.completeness = completeness
        self.satisfaction = satisfaction
        self.score = score
    }

}
