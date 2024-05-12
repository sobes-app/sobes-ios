import SwiftUI
import UIComponents
import Types

public struct InterviewStatisticsView<Model: InterviewViewModel>: View {

    public init(model: Model, showTabBar: Binding<Bool>) {
        self._model = ObservedObject(wrappedValue: model)
        self._profession = State(initialValue: model.professions.first ?? .project)
        self._showTabBar = showTabBar
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            VStack(alignment: .leading, spacing: Constants.topPadding) {
                BackButton()
                professionsPicker
                statisticsBubble
            }
            questions
        }
        .padding(.horizontal, Constants.horizontal)
        .navigationBarBackButtonHidden()
        .onAppear {
            withAnimation {
                showTabBar.toggle()
            }
        }
        .onDisappear {
            withAnimation {
                showTabBar.toggle()
            }
        }
        .task {
            await model.fetchUserQuestions(profession: profession.rawValue)
            model.fetchUserStatistics(profession: profession.rawValue)
        }
        .onChange(of: profession) {
            Task { @MainActor in
                await model.fetchUserQuestions(profession: profession.rawValue)
                model.fetchUserStatistics(profession: profession.rawValue)
            }
        }
    }

    @ObservedObject private var model: Model
    @State private var profession: Professions
    @Binding private var showTabBar: Bool

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
            Text("Твоя статистика по ответам на вопросы")
                .font(Fonts.heading)
                .foregroundStyle(.black)

            Text("\(model.getPublicStatistics(type: .inWork, profession: profession))")
                .foregroundColor(Color(.accent))
                .font(Fonts.mainBold)
            +
            Text(" в проработке")
                .font(Fonts.main)

            Text("\(model.getPublicStatistics(type: .ideal, profession: profession))")
                .foregroundColor(Color(.accent))
                .font(Fonts.mainBold)
            +
            Text(" с идеальным результатом")
                .font(Fonts.main)

            Text("\(model.getPublicStatistics(type: .meanResult, profession: profession))%")
                .foregroundColor(Color(.accent))
                .font(Fonts.mainBold)
            +
            Text(" средний результат")
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
                .foregroundStyle(.black)
            if model.isLoading {
                LoadingScreen(placeholder: "Загружаем вопросы...")
            } else {
                questionsLoaded
            }
        }
    }

    @ViewBuilder
    private var questionsLoaded: some View {
        if model.questions.isEmpty {
            VStack(alignment: .leading, spacing: Constants.topPadding) {
                Spacer()
                Text("Ты еще не отвечал на вопросы")
                    .font(Fonts.main)
                    .foregroundStyle(Color(.gray))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            }
        } else {
            ScrollView {
                VStack(spacing: Constants.defSpacing) {
                    ForEach(model.questions) { question in
                        NavigationLink(destination: InterviewChatView(model: model, question: question, showTabBar: $showTabBar)) {
                            ChevronButton(model: .question(question))
                        }
                    }
                }
                Spacer()
            }
        }
    }

    private func number(_ n: Int, _ titles: [String]) -> String {
        let cases = [2, 0, 1, 1, 1, 2]
        return titles[(n % 100 > 4 && n % 100 < 20) ? 2 : cases[min(n % 10, 5)]]
    }

}
