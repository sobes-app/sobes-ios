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
                .foregroundStyle(.black)
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
            HStack(spacing: 20) {
                Text(message.text)
                    .foregroundStyle(.black)
                    .font(Fonts.main)
                    .multilineTextAlignment(.leading)
                    .padding(Constants.smallStack)
                    .background {
                        RoundedRectangle(cornerRadius: Constants.corner)
                            .foregroundStyle(Color(.bubble))
                    }
                if isAssessment {
                    Image(systemName: "chevron.right")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .foregroundStyle(Color(.grey))
                        .bold()
                        .padding(.leading, 4)
                }
                Spacer()
            }
            .frame(maxWidth: 266, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var message: InterviewMessage

}
