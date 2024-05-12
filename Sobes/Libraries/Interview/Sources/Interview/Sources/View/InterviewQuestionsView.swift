import SwiftUI
import Types
import UIComponents

public struct InterviewQuestionsView<Model: InterviewViewModel>: View {

    public init(model: Model, type: Professions, showTabBar: Binding<Bool>) {
        self._model = ObservedObject(wrappedValue: model)
        self.type = type
        self._showTabBar = showTabBar
    }

    public var body: some View {
        VStack(spacing: Constants.topPadding) {
            navBar
            questionsBlock
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
            await model.fetchQuestions(for: type)
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

    private var questionsBlock: some View {
        VStack(spacing: Constants.topPadding) {
            Text("Подготовили список вопросов на сегодня")
                .font(Fonts.heading)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            questionsAndButton
        }
        .overlay {
            if model.isLoading {
                LoadingScreen(placeholder: "Подготавливаем вам вопросы...")
            }
            if model.isError {
                ErrorView(retryAction: {
                    Task { @MainActor in
                        await model.fetchQuestions(for: type)
                    }
                })
            }
        }
    }

    private var questionsAndButton: some View {
        VStack(spacing: Constants.smallStack) {
            ScrollView {
                VStack(spacing: Constants.defSpacing) {
                    ForEach(model.questions) { question in
                        NavigationLink(destination: InterviewChatView(model: model, question: question, showTabBar: $showTabBar)) {
                            ChevronButton(model: .question(question))
                        }
                    }
                }
            }
            Spacer()
            changeQuestionsButton
        }
    }

    private var changeQuestionsButton: some View {
        MainButton(
            action: {
                Task { @MainActor in
                    await model.fetchQuestions(for: type)
                }
            },
            label: "Поменять вопросы"
        )
        .padding(.bottom, 20)
    }

    private let type: Professions
    @ObservedObject private var model: Model
    @Binding private var showTabBar: Bool

}
