import SwiftUI
import Types

@MainActor
public protocol InterviewViewModel: ObservableObject {
    var messages: [InterviewMessage] { get }
    var questions: [InterviewQuestion] { get }
    func onViewAppear()
    func fetchQuestions()
    func shuffleQuestions()
    func onUserMessageSent(text: String)
    func startDialogueForQuestion(text: String)
}

@MainActor
public final class InterviewViewModelImpl: InterviewViewModel {

    @Published public var messages: [InterviewMessage] = []
    @Published public var questions: [InterviewQuestion] = []

    public init() {
    }

    public func onViewAppear() {
    }

    public func shuffleQuestions() {
        questions = [
            InterviewQuestion(id: 0, text: "Как вы определяете и приоритизируете продуктовые требования?"),
            InterviewQuestion(id: 1, text: "Расскажите о проекте, который не удался. Каковы были причины и что вы из этого извлекли?"),
            InterviewQuestion(id: 2, text: "С какими методологиями управления проектами вы имели дело и какие предпочитаете?"),
        ]
    }

    public func fetchQuestions() {
        questions = [
            InterviewQuestion(id: 0, text: "Расскажите о случае, когда вам пришлось работать в команде, где возникли конфликты или разногласия между членами команды. Как вы управляли этой ситуацией?"),
            InterviewQuestion(id: 1, text: "Расскажите о вашем опыте работы в сфере менеджмента"),
            InterviewQuestion(id: 2, text: "Перечислите ваши положительные качества")
        ]
    }

    public func startDialogueForQuestion(text: String) {
        messages.removeAll()
        messages.append(InterviewMessage(id: 0, text: "Привет, я твой интервьюер на сегодняшний день. Давай начнем с такого вопроса...", sender: .gpt(isAssessment: false)))
        messages.append(InterviewMessage(id: 1, text: text, sender: .gpt(isAssessment: false)))
    }

    public func onUserMessageSent(text: String) {
        let messageId = (messages.last?.id ?? -1) + 1
        messages.append(InterviewMessage(id: messageId, text: text, sender: .user))
    }

}
