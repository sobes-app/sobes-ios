import SwiftUI
import Types
import UIComponents

public struct InterviewChatView<Model: InterviewViewModel>: View {

    public init(model: Model, question: InterviewQuestion) {
        self._model = ObservedObject(wrappedValue: model)
        self.question = question
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Constants.topPadding) {
            BackButton()
            messageBubbles
            Spacer()
            TextFieldView(model: .chat, input: $input, onSend: {
                model.onUserMessageSent(question: question.text, text: input)
            })
        }
        .navigationBarBackButtonHidden()
        .padding(Constants.horizontal)
        .task {
            await model.startDialogueForQuestion(question: question.text, questionId: question.id, text: question.text)
        }
    }

    @State private var input: String = ""
    @ObservedObject private var model: Model
    private let question: InterviewQuestion

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
                                        answer: model.messages[message.id - 1].text
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
            .onChange(of: model.messages) { message in
                withAnimation {
                    proxy.scrollTo("bottom")
                }
            }
        }
        .scrollIndicators(.hidden)
    }

}
