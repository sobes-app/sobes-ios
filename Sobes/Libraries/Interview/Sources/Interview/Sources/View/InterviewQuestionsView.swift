import SwiftUI
import UIComponents

public struct InterviewQuestionsView: View {

    public enum InterviewType: String {
        case ba = "Бизнес-аналитик"
        case product = "Менеджер продукта"
        case project = "Менеджер проектов"
    }

    public init(type: InterviewType) {
        self.type = type
    }

    public var body: some View {
        VStack(spacing: 20) {
            navBar
            heading
            questions
            Spacer()
            changeQuestionsButton
        }
        .padding(.horizontal, 31)
    }

    private var navBar: some View {
        HStack(spacing: 16) {
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
            VStack(spacing: 16) {
                ChevronButton(model: .question(text: "Расскажите о случае, когда вам пришлось работать в команде, где возникли конфликты или разногласия между членами команды. Как вы управляли этой ситуацией?"))
                ChevronButton(model: .question(text: "Расскажите о случае, когда вам пришлось работать в команде, где возникли конфликты или разногласия между членами команды. Как вы управляли этой ситуацией?", result: 72.5))
                ChevronButton(model: .question(text: "Расскажите о случае, когда вам пришлось работать в команде, где возникли конфликты или разногласия между членами команды. Как вы управляли этой ситуацией?"))
            }
        }
    }

    private var changeQuestionsButton: some View {
        MainButton(action: {}, label: "Поменять вопросы")
            .padding(.bottom, 20)
    }

    private let type: InterviewType

}
