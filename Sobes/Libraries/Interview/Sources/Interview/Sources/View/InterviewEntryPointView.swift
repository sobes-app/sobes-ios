import SwiftUI
import UIComponents
import Toolbox

public struct InterviewEntryPointView<Model: InterviewViewModel>: View {

    public init(showTabBar: Binding<Bool>, model: Model) {
        self._showTabBar = showTabBar
        self._model = StateObject(wrappedValue: model)
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                headline
                interviewButtons
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, Constants.horizontal)
        }
        .task {
            await model.onViewAppear()
        }
    }

    @StateObject private var model: Model
    @Binding private var showTabBar: Bool

    private var headline: some View {
        HStack {
            Text("Раздел\nподготовки")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(Fonts.heading)
                .foregroundStyle(.black)
            Spacer()
            statisticsButton
        }
    }

    private var statisticsButton: some View {
        NavigationLink(destination: InterviewStatisticsView(model: model, showTabBar: $showTabBar)) {
            Image(systemName: "chart.xyaxis.line")
                .foregroundColor(.black)
                .padding(Constants.elementPadding)
                .background {
                    RoundedRectangle(cornerRadius: Constants.corner)
                        .foregroundColor(Color(.light))
                }
        }
    }

    @ViewBuilder
    private var interviewButtons: some View {
        if model.isLoading {
            LoadingScreen(placeholder: "Готовим для вас интервью...")
        } else {
            VStack(spacing: Constants.defSpacing) {
                if model.professions.isEmpty {
                    Spacer()
                    Text("Для начала необходимо заполнить информацию о профессиях в профиле")
                        .font(Fonts.main)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                    Spacer()
                } else {
                    ForEach(model.professions, id: \.self) { profession in
                        NavigationLink(destination: InterviewQuestionsView(model: model, type: profession, showTabBar: $showTabBar)) {
                            ChevronButton(model: .button(text: profession.rawValue))
                        }
                    }
                }
            }
        }
    }
}
