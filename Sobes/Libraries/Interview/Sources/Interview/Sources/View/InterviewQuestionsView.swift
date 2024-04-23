import SwiftUI
import UIComponents

public struct InterviewQuestionsView<Model: InterviewViewModel>: View {

    public enum InterviewType: String {
        case ba = "Бизнес-аналитик"
        case product = "Менеджер продукта"
        case project = "Менеджер проектов"
    }

    public init(model: Model, type: InterviewType) {
        self._model = ObservedObject(wrappedValue: model)
        self.type = type
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: Constants.topPadding) {
                navBar
                heading
                questions
                Spacer()
                changeQuestionsButton
            }
            .padding(.horizontal, Constants.horizontal)
        }
    }

    private var navBar: some View {
        HStack(spacing: Constants.defSpacing) {
            BackButton()
            Text(type.rawValue)
                .font(Font.custom("CoFoSans-Regular", size: 17))
            Spacer()
        }
    }

    private var heading: some View {
        Text("Подготовили список вопросов на сегодня")
            .font(Font.custom("CoFoSans-Bold", size: 23))
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var questions: some View {
        ScrollView {
            VStack(spacing: Constants.defSpacing) {
                NavigationLink(destination: InterviewChatView(messages: [.init(id: 0, text: "Hi", sender: .gpt(isAssessment: false))])) {
                    ChevronButton(model: .question(text: "Расскажите о случае, когда вам пришлось работать в команде, где возникли конфликты или разногласия между членами команды. Как вы управляли этой ситуацией?"))
                }
//                NavigationLink(destination: InterviewChatView) {
                    ChevronButton(model: .question(text: "Расскажите о случае, когда вам пришлось работать в команде, где возникли конфликты или разногласия между членами команды. Как вы управляли этой ситуацией?", result: 72.5))
//                }


                ChevronButton(model: .question(text: "Расскажите о случае, когда вам пришлось работать в команде, где возникли конфликты или разногласия между членами команды. Как вы управляли этой ситуацией?"))
            }
        }
    }

    private var changeQuestionsButton: some View {
        MainButton(
            action: {
                model.shuffleQuestions()
            },
            label: "Поменять вопросы"
        )
        .padding(.bottom, 20)
    }

    private let type: InterviewType
    @ObservedObject private var model: Model

}
