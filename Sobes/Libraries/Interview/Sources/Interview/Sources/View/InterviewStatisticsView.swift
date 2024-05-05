import SwiftUI
import UIComponents
import Types

public struct InterviewStatisticsView<Model: InterviewViewModel>: View {

    public init(model: Model) {
        self._model = ObservedObject(wrappedValue: model)
        self._profession = State(initialValue: model.professions.first ?? .project)
    }

    public var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 32) {
                if model.questions.isEmpty {
                    emptyView
                } else {
                    VStack(alignment: .leading, spacing: Constants.topPadding) {
                        BackButton()
                        professionsPicker
                        statisticsBubble
                    }
                    questions
                    Spacer()
                }
            }
            .padding(.horizontal, Constants.horizontal)
        }
        .navigationBarBackButtonHidden()
        .task {
            await model.fetchUserQuestions(profession: profession.rawValue)
        }
    }

    @ObservedObject private var model: Model
    @State private var profession: Professions

    private var emptyView: some View {
        VStack(alignment: .leading, spacing: Constants.topPadding) {
            BackButton()
            Spacer()
            Text("Ты еще не отвечал на вопросы")
                .font(Fonts.main)
                .foregroundStyle(Color(.gray))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
        }
    }

    private var professionsPicker: some View {
        Picker("Pick profession", selection: $profession) {
            ForEach(model.professions, id: \.self) { profession in
                Text(profession.rawValue)
                    .font(Fonts.small)
                    .foregroundStyle(.black)
            }
        }
        .foregroundStyle(.blue)
        .frame(maxWidth: .infinity)
        .pickerStyle(.segmented)
    }

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
            if model.questions.isEmpty {

            } else {
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

}
