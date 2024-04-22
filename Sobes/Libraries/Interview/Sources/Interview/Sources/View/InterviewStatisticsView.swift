import SwiftUI
import UIComponents

public struct InterviewStatisticsView<Model: InterviewViewModel>: View {

    public init(model: Model) {
        self._model = StateObject(wrappedValue: model)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            VStack(alignment: .leading, spacing: 20) {
                BackButton()
                statisticsBubble
            }
            questions
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 31)
        .navigationBarBackButtonHidden()
    }

    private var statisticsBubble: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Твоя статистика")
                .font(Font.custom("CoFoSans-Bold", size: 23))
                .foregroundStyle(.black)

            Text("26")
                .foregroundColor(Color(.accent))
                .font(Font.custom("CoFoSans-Bold", size: 17))
            +
            Text(" вопросов в проработке")
                .font(Font.custom("CoFoSans-Regular", size: 17))

            Text("5")
                .foregroundColor(Color(.accent))
                .font(Font.custom("CoFoSans-Bold", size: 17))
            +
            Text(" вопросов с идеальным результатом")
                .font(Font.custom("CoFoSans-Regular", size: 17))

            Text("87%")
                .foregroundColor(Color(.accent))
                .font(Font.custom("CoFoSans-Bold", size: 17))
            +
            Text(" средний результат по вопросам")
                .font(Font.custom("CoFoSans-Regular", size: 17))
        }
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.black, lineWidth: 1)
        }
    }

    private var questions: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Твои вопросы")
                .font(Font.custom("CoFoSans-Bold", size: 23))
            ChevronButton(model: .question(text: "Расскажите о случае, когда вам пришлось работать в команде, где возникли конфликты или разногласия между членами команды. Как вы управляли этой ситуацией?", result: 72.5))
        }
    }

    @StateObject private var model: Model

}
