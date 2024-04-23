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
            TextFieldView(model: .chat, input: $input, inputState: $inputState, onSend: {
                model.onUserMessageSent(text: input)
            })
        }
        .navigationBarBackButtonHidden()
        .padding(Constants.horizontal)
        .onAppear {
            model.startDialogueForQuestion(text: question.text)
        }
    }

    @State private var input: String = ""
    @State private var inputState: TextFieldView.InputState = .correct
    @ObservedObject private var model: Model
    private let question: InterviewQuestion

    private var messageBubbles: some View {
        ScrollView {
            VStack(spacing: Constants.smallStack) {
                ForEach(model.messages) { message in
                    InterviewMessageBubble(message: message)
                }
            }
        }
    }

}
