import SwiftUI
import UIComponents

public struct InterviewStatisticsView<Model: InterviewViewModel>: View {

    public init(model: Model) {
        self._model = ObservedObject(wrappedValue: model)
    }

    public var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 32) {
                VStack(alignment: .leading, spacing: Constants.topPadding) {
                    BackButton()
                    statisticsBubble
                }
                questions
                Spacer()
            }
            .padding(.horizontal, Constants.horizontal)
        }
        .navigationBarBackButtonHidden()
        .task {
            await model.fetchUserQuestions(profession: "Менеджер проекта")
        }
    }

    @ObservedObject private var model: Model

    private var statisticsBubble: some View {
        VStack(alignment: .leading, spacing: Constants.smallStack) {
            Text("Твоя статистика")
                .font(Fonts.heading)
                .foregroundStyle(.black)

            Text(model.getQuestionsInProgress())
                .foregroundColor(Color(.accent))
                .font(Fonts.mainBold)
            +
            Text(" вопросов в проработке")
                .font(Fonts.main)

            Text(model.getQuestionsWithIdealResult())
                .foregroundColor(Color(.accent))
                .font(Fonts.mainBold)
            +
            Text(" вопросов с идеальным результатом")
                .font(Fonts.main)

            Text(model.getMeanQuestionsResult())
                .foregroundColor(Color(.accent))
                .font(Fonts.mainBold)
            +
            Text(" средний результат по вопросам")
                .font(Fonts.main)
        }
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Constants.elementPadding)
        .background {
            RoundedRectangle(cornerRadius: Constants.corner)
                .stroke(.black, lineWidth: Constants.strokeWidth)
        }
    }

    private var questions: some View {
        VStack(alignment: .leading, spacing: Constants.defSpacing) {
            Text("Твои вопросы")
                .font(Fonts.heading)
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
    }

}
