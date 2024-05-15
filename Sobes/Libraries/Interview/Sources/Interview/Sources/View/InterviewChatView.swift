import SwiftUI
import Types
import UIComponents

public struct InterviewChatView<Model: InterviewViewModel>: View {

    public init(model: Model, question: InterviewQuestion, showTabBar: Binding<Bool>) {
        self._model = ObservedObject(wrappedValue: model)
        self.question = question
        self._showTabBar = showTabBar
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Constants.topPadding) {
            BackButton()
            Group {
                messageBubbles
                Spacer()
                TextFieldView(model: .chat, input: $input, onSend: {
                    model.onUserMessageSent(question: question.text, text: input)
                })
            }
            .overlay {
                if model.isLoading {
                    LoadingScreen(placeholder: "Загружаем чат...")
                }
                if model.isError {
                    ErrorView(retryAction: {
                        Task { @MainActor in
                            await model.startDialogueForQuestion(question: question.text, questionId: question.id, text: question.text)
                        }
                    })
                }
            }
        }
        .navigationBarBackButtonHidden()
        .padding(Constants.horizontal)
        .task {
            await model.startDialogueForQuestion(question: question.text, questionId: question.id, text: question.text)
        }
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
    }

    @State private var input: String = ""
    @ObservedObject private var model: Model
    private let question: InterviewQuestion
    @Binding private var showTabBar: Bool

    private var messageBubbles: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: Constants.smallStack) {
                    ForEach(model.messages) { message in
                        if case .gpt(let assessment) = message.sender {
                            if assessment {
                                NavigationLink(
                                    destination: InterviewAssessmentView(
                                        model: model,
                                        question: question.text,
                                        answer: model.messages[message.id - 1].text, 
                                        showTabBar: $showTabBar
                                    )
                                ) {
                                    InterviewMessageBubble(message: message)
                                }
                            } else {
                                InterviewMessageBubble(message: message)
                            }
                        } else {
                            InterviewMessageBubble(message: message)
                        }
                    }
                }
                Spacer()
                    .frame(height: 0)
                    .id("bottom")
            }
            .onChange(of: model.messages) {
                withAnimation {
                    proxy.scrollTo("bottom")
                }
            }
        }
        .scrollIndicators(.hidden)
    }

}
