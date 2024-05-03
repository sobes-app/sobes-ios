import Foundation

public struct InterviewAssessment {

    public let improvement: String
    public let completeness: Int
    public let satisfaction: Int
    public let score: Double

    public init(improvement: String, completeness: Int, satisfaction: Int, score: Double) {
        self.improvement = improvement
        self.completeness = completeness
        self.satisfaction = satisfaction
        self.score = score
    }

}
