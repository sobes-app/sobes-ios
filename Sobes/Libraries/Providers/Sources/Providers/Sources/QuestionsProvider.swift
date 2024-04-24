import SwiftUI
import Types

public protocol QuestionsProvider {
    func getProjectQuestions() -> [Types.InterviewQuestion]
    func getProductQuestions() -> [Types.InterviewQuestion]
    func getBAQuestions() -> [Types.InterviewQuestion]
    func getUserQuestions() -> [Types.InterviewQuestion]
    func addMessageToInterviewChat(questionId: Int, message: InterviewMessage)
    func areQuestionMessagesEmpty(id: Int) -> Bool
    func getMessagesForQuestion(id: Int) -> [InterviewMessage]
}

public final class QuestionsProviderImpl: QuestionsProvider {

    public init() { }

    public func areQuestionMessagesEmpty(id: Int) -> Bool {
        return questions[id].messages.isEmpty
    }

    public func getMessagesForQuestion(id: Int) -> [InterviewMessage] {
        return questions[id].messages
    }

    public func getProjectQuestions() -> [Types.InterviewQuestion] {
        return questions.filter { $0.questionType == .project || $0.questionType == .general }
    }

    public func getProductQuestions() -> [Types.InterviewQuestion] {
        return questions.filter { $0.questionType == .product || $0.questionType == .general }
    }

    public func getBAQuestions() -> [Types.InterviewQuestion] {
        return questions.filter { $0.questionType == .ba || $0.questionType == .general }
    }

    public func getUserQuestions() -> [Types.InterviewQuestion] {
        return questions.filter { $0.result != nil }
    }

    public func addMessageToInterviewChat(questionId: Int, message: InterviewMessage) {
        questions[questionId].messages.append(message)
    }

    private var questions: [Types.InterviewQuestion] = [
        InterviewQuestion(id: 0, questionType: .project, text: "Расскажите о случае, когда вам пришлось работать в команде, где возникли конфликты или разногласия между членами команды. Как вы управляли этой ситуацией?", messages: []),
        InterviewQuestion(id: 1, questionType: .project, text: "Расскажите о вашем опыте работы в сфере менеджмента", messages: []),
        InterviewQuestion(id: 2, questionType: .general, text: "Перечислите ваши положительные качества", messages: []),
        InterviewQuestion(id: 3, questionType: .project, text: "Как вы организуете процесс управления проектом?", messages: []),
        InterviewQuestion(id: 4, questionType: .project, text: "Как вы справляетесь с изменениями в проекте и как вы управляете ожиданиями заинтересованных сторон?", messages: []),
        InterviewQuestion(id: 5, questionType: .project, text: "Расскажите о проекте, который потерпел неудачу под вашим руководством. Чему это научило вас?", messages: []),
        InterviewQuestion(id: 6, questionType: .project, text: "Как вы мотивируете свою команду, особенно в трудные периоды проекта?", messages: []),
        InterviewQuestion(id: 7, questionType: .project, text: "Как вы определяете приоритеты в проекте, если ресурсы ограничены и все задачи кажутся критически важными?", messages: []),
        InterviewQuestion(id: 8, questionType: .product, text: "Как вы определяете целевую аудиторию для нового продукта и какие стратегии вы используете для вовлечения этой аудитории?", messages: []),
        InterviewQuestion(id: 9, questionType: .product, text: "Как вы определяете успех продукта и какие метрики вы используете для измерения этого успеха?", messages: []),
        InterviewQuestion(id: 10, questionType: .product, text: "Расскажите о продукте, который вы разрабатывали с нуля. Какие этапы вы проходили от идеи до запуска?", messages: []),
        InterviewQuestion(id: 11, questionType: .product, text: "Как вы работаете с отзывами пользователей и как внедряете их в процесс разработки продукта?", messages: []),
        InterviewQuestion(id: 12, questionType: .ba, text: "Опишите процесс, который вы обычно используете для анализа бизнес-проблемы.", messages: []),
        InterviewQuestion(id: 13, questionType: .ba, text: "Как вы определяете и приоритизируете требования заинтересованных сторон?", messages: []),
        InterviewQuestion(id: 14, questionType: .ba, text: "Могли бы вы рассказать о проекте, в котором вы использовали данные для решения конкретной бизнес-задачи? Какие инструменты аналитики вы использовали?", messages: []),
        InterviewQuestion(id: 15, questionType: .ba, text: "Как вы общаетесь со сложной технической информацией с  не-техническим пользователям? Приведите пример.", messages: []),
        InterviewQuestion(id: 16, questionType: .ba, text: "Расскажите о случае, когда вы столкнулись с неоднозначными или неполными данными. Как вы поступили, чтобы решить задачу?", messages: []),
        InterviewQuestion(id: 17, questionType: .general, text: "Расскажите о ситуации, когда вам пришлось работать под строгими сроками. Как вы справлялись с давлением?", messages: []),
        InterviewQuestion(id: 18, questionType: .general, text: "Опишите проект, в котором вы принимали участие и который вы считаете наиболее успешным. Что именно сделало его успешным?", messages: []),
        InterviewQuestion(id: 19, questionType: .general, text: "Как вы себя обучаете новым технологиям или инструментам? Возможно, есть пример, когда вы успешно освоили новое для себя направление?", messages: []),
        InterviewQuestion(id: 20, questionType: .general, text: "Как вы справляетесь с неудачами в работе? Приведите пример ситуации, когда что-то пошло не так, и что вы из этого извлекли.", result: 90, messages: []),
    ]

}
