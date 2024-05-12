import Foundation

public struct InterviewStatistics {

    public init(questionsInWork: Int, questionsIdealResult: Int, questionsMeanResult: Int) {
        self.questionsInWork = questionsInWork
        self.questionsIdealResult = questionsIdealResult
        self.questionsMeanResult = questionsMeanResult
    }

    public let questionsInWork: Int
    public let questionsIdealResult: Int
    public let questionsMeanResult: Int

}
