import SwiftUI
import Types
import NetworkLayer
import SwiftyKeychainKit

public protocol QuestionsProvider {
    func getProjectQuestions() async -> [Types.InterviewQuestion]
    func getProductQuestions() async -> [Types.InterviewQuestion]
    func getBAQuestions() async -> [Types.InterviewQuestion]
    func getUserQuestions(profession: String) async -> [Types.InterviewQuestion]
    func addMessageToInterviewChat(question: String, message: InterviewMessage)
    func areQuestionMessagesEmpty(question: String) async -> Bool
    func getMessagesForQuestion(question: String) -> [InterviewMessage]
    func getAnswerAssessment(question: String, answer: String, profession: String) async -> InterviewAssessment?
}

public final class QuestionsProviderImpl: QuestionsProvider {

    public init() { }

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

    public func getProjectQuestions() async -> [Types.InterviewQuestion] {
        let interviewClient = InterviewClient(token: try? self.keychain.get(accessTokenKey))
        let result = await interviewClient.generateQuestions(profession: "Менеджер проекта", level: "Junior")
        switch result {
        case .success(let questions):
            return questions.enumerated().map { (index, question) in
                InterviewQuestion(id: index, questionType: .project, text: question.question)
            }
        case .failure:
            return []
        }
    }

    public func getProductQuestions() async -> [Types.InterviewQuestion] {
        let interviewClient = InterviewClient(token: try? self.keychain.get(accessTokenKey))
        let result = await interviewClient.generateQuestions(profession: "Менеджер продукта", level: "Junior")
        switch result {
        case .success(let questions):
            return questions.enumerated().map { (index, question) in
                InterviewQuestion(id: index, questionType: .product, text: question.question)
            }
        case .failure:
            return []
        }
    }

    public func getBAQuestions() async -> [Types.InterviewQuestion] {
        let interviewClient = InterviewClient(token: try? self.keychain.get(accessTokenKey))
        let result = await interviewClient.generateQuestions(profession: "Бизнес-аналитик", level: "Junior")
        switch result {
        case .success(let questions):
            return questions.enumerated().map { (index, question) in
                InterviewQuestion(id: index, questionType: .ba, text: question.question)
            }
        case .failure:
            return []
        }
    }

    public func getAnswerAssessment(question: String, answer: String, profession: String) async -> InterviewAssessment? {
        let interviewClient = InterviewClient(token: try? self.keychain.get(accessTokenKey))
        let result = await interviewClient.getAssessment(question: question, answer: answer, profession: profession)
        switch result {
        case .success(let assessment):
            return InterviewAssessment(
                improvement: assessment.improvement,
                completeness: assessment.completeness,
                satisfaction: assessment.satisfaction,
                score: assessment.score
            )
        case .failure:
            return nil
        }
    }

    public func getUserQuestions(profession: String) async -> [Types.InterviewQuestion] {
        let interviewClient = InterviewClient(token: try? self.keychain.get(accessTokenKey))
        let result = await interviewClient.getAnsweredQuestion(profession: profession, level: "Junior")
        switch result {
        case .success(let questions):
            return questions.map {
                InterviewQuestion(
                    id: $0.id,
                    questionType: InterviewQuestion.QuestionType(rawValue: $0.profession.profession) ?? .project,
                    text: $0.content
                )
            }
        case .failure:
            return []
        }
    }

    public func addMessageToInterviewChat(question: String, message: InterviewMessage) {
        if chats[question] == nil {
            chats[question] = []
        }
        chats[question]?.append(message)
        print(chats[question])
    }

    private let keychain: Keychain = Keychain(service: "com.swifty.keychain")
    private let accessTokenKey = KeychainKey<String>(key: "accessToken")
    private var chats: [String : [InterviewMessage]] = [:]

//    private var questions: [Types.InterviewQuestion] = [
//        InterviewQuestion(id: 0, questionType: .project, text: "Расскажите о случае, когда вам пришлось работать в команде, где возникли конфликты или разногласия между членами команды. Как вы управляли этой ситуацией?", messages: []),
//        InterviewQuestion(id: 1, questionType: .project, text: "Расскажите о вашем опыте работы в сфере менеджмента", messages: []),
//        InterviewQuestion(id: 3, questionType: .project, text: "Как вы организуете процесс управления проектом?", messages: []),
//        InterviewQuestion(id: 4, questionType: .project, text: "Как вы справляетесь с изменениями в проекте и как вы управляете ожиданиями заинтересованных сторон?", messages: []),
//        InterviewQuestion(id: 5, questionType: .project, text: "Расскажите о проекте, который потерпел неудачу под вашим руководством. Чему это научило вас?", messages: []),
//        InterviewQuestion(id: 6, questionType: .project, text: "Как вы мотивируете свою команду, особенно в трудные периоды проекта?", messages: []),
//        InterviewQuestion(id: 7, questionType: .project, text: "Как вы определяете приоритеты в проекте, если ресурсы ограничены и все задачи кажутся критически важными?", messages: []),
//        InterviewQuestion(id: 8, questionType: .product, text: "Как вы определяете целевую аудиторию для нового продукта и какие стратегии вы используете для вовлечения этой аудитории?", messages: []),
//        InterviewQuestion(id: 9, questionType: .product, text: "Как вы определяете успех продукта и какие метрики вы используете для измерения этого успеха?", messages: []),
//        InterviewQuestion(id: 10, questionType: .product, text: "Расскажите о продукте, который вы разрабатывали с нуля. Какие этапы вы проходили от идеи до запуска?", messages: []),
//        InterviewQuestion(id: 11, questionType: .product, text: "Как вы работаете с отзывами пользователей и как внедряете их в процесс разработки продукта?", messages: []),
//        InterviewQuestion(id: 12, questionType: .ba, text: "Опишите процесс, который вы обычно используете для анализа бизнес-проблемы.", messages: []),
//        InterviewQuestion(id: 13, questionType: .ba, text: "Как вы определяете и приоритизируете требования заинтересованных сторон?", messages: []),
//        InterviewQuestion(id: 14, questionType: .ba, text: "Могли бы вы рассказать о проекте, в котором вы использовали данные для решения конкретной бизнес-задачи? Какие инструменты аналитики вы использовали?", messages: []),
//        InterviewQuestion(id: 15, questionType: .ba, text: "Как вы общаетесь со сложной технической информацией с  не-техническим пользователям? Приведите пример.", messages: []),
//        InterviewQuestion(id: 16, questionType: .ba, text: "Расскажите о случае, когда вы столкнулись с неоднозначными или неполными данными. Как вы поступили, чтобы решить задачу?", messages: []),
//        InterviewQuestion(id: 17, questionType: .general, text: "Расскажите о ситуации, когда вам пришлось работать под строгими сроками. Как вы справлялись с давлением?", messages: []),
//        InterviewQuestion(id: 18, questionType: .general, text: "Опишите проект, в котором вы принимали участие и который вы считаете наиболее успешным. Что именно сделало его успешным?", messages: []),
//        InterviewQuestion(id: 19, questionType: .general, text: "Как вы себя обучаете новым технологиям или инструментам? Возможно, есть пример, когда вы успешно освоили новое для себя направление?", messages: []),
//        InterviewQuestion(id: 20, questionType: .general, text: "Как вы справляетесь с неудачами в работе? Приведите пример ситуации, когда что-то пошло не так, и что вы из этого извлекли.", result: 90, messages: []),
//    ]

}
