import SwiftUI
import Types
import UIComponents

public struct InterviewChatView: View {

    var messages: [InterviewMessage]

    public var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            BackButton()
            messages
        }
    }

    private var messages: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(messages) { message in
                    InterviewMessageBubble(message: InterviewMessage(id: 0, text: "привет, я твой интервьюер на сегодняшний день, давай начнем с такого вопроса...", sender: .gpt(isAssessment: false)))
                }
            }
        }
    }

}
