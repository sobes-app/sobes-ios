import SwiftUI
import Types

public struct InterviewMessageBubble: View {

    public init(message: InterviewMessage) {
        self.message = message
    }

    public var body: some View {
        switch message.sender {
        case .user:
            userMessage
        case .gpt(let isAssessment):
            gptMessage(isAssessment: isAssessment)
        }
    }

    private var userMessage: some View {
        HStack {
            Spacer()
            Text(message.text)
                .multilineTextAlignment(.trailing)
                .font(Fonts.main)
                .padding(Constants.smallStack)
                .background {
                    RoundedRectangle(cornerRadius: Constants.corner)
                        .stroke(.black, lineWidth: Constants.strokeWidth)
                }
                .frame(maxWidth: Constants.messageMaxWidth, alignment: .trailing)
        }
    }

    private func gptMessage(isAssessment: Bool) -> some View {
        HStack(spacing: 17) {
            Image(systemName: "face.smiling.inverse")
                .resizable()
                .scaledToFit()
                .frame(height: 26)
                .foregroundStyle(Color(.accent))
            Text(message.text)
                .font(Fonts.main)
                .multilineTextAlignment(.leading)
                .padding(Constants.smallStack)
                .background {
                    RoundedRectangle(cornerRadius: Constants.corner)
                        .foregroundStyle(Color(.bubble))
                }
                .frame(maxWidth: Constants.messageMaxWidth, alignment: .leading)
            if isAssessment {
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 16)
                    .foregroundStyle(Color(.grey))
                    .padding(.leading, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var message: InterviewMessage

}
