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
        Text(message.text)
            .font(Font.custom("CoFoSans-Regular", size: 13))
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 1)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
    }

    private func gptMessage(isAssessment: Bool) -> some View {
        HStack(spacing: 17) {
            Image(systemName: "face.smiling.inverse")
                .resizable()
                .scaledToFit()
                .frame(height: 26)
                .foregroundStyle(Color(.accent))
            Text(message.text)
                .font(Font.custom("CoFoSans-Regular", size: 13))
                .multilineTextAlignment(.leading)
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color(.bubble))
                }
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
