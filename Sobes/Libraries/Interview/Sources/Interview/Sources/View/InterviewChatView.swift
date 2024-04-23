import SwiftUI
import Types
import UIComponents

public struct InterviewChatView: View {

    var messages: [InterviewMessage]

    public var body: some View {
        VStack(alignment: .leading, spacing: Constants.topPadding) {
            BackButton()
            messageBubbles
            Spacer()
            TextFieldView(model: .chat, input: $input, inputState: $inputState, isSendButtonAvailable: true)
        }
        .navigationBarBackButtonHidden()
        .padding(Constants.horizontal)
    }

    @State private var input: String = ""
    @State private var inputState: TextFieldView.InputState = .correct

    private var messageBubbles: some View {
        ScrollView {
            VStack(spacing: Constants.smallStack) {
                ForEach(messages) { message in
                    InterviewMessageBubble(message: InterviewMessage(id: 0, text: "привет, я твой интервьюер на сегодняшний день, давай начнем с такого вопроса...", sender: .gpt(isAssessment: false)))
                }
            }
        }
    }

}
