import SwiftUI
import UIComponents

public enum InterviewType: String {
    case ba = "Бизнес-аналитик"
    case product = "Менеджер продукта"
    case project = "Менеджер проектов"
}

public struct InterviewQuestionsView<Model: InterviewViewModel>: View {

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
        .onAppear {
            model.fetchQuestions(for: type)
        }
    }

    private var navBar: some View {
        HStack(spacing: Constants.defSpacing) {
            BackButton()
            Text(type.rawValue)
                .font(Fonts.main)
            Spacer()
        }
    }

    private var heading: some View {
        Text("Подготовили список вопросов на сегодня")
            .font(Fonts.heading)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var questions: some View {
        ScrollView {
            VStack(spacing: Constants.defSpacing) {
                ForEach(model.questions) { question in
                    NavigationLink(destination: InterviewChatView(model: model, question: question)) {
                        ChevronButton(model: .question(question))
                    }
                }
            }
        }
    }

    private var changeQuestionsButton: some View {
        MainButton(
            action: {
                model.fetchQuestions(for: type)
            },
            label: "Поменять вопросы"
        )
        .padding(.bottom, 20)
    }

    private let type: InterviewType
    @ObservedObject private var model: Model

}
