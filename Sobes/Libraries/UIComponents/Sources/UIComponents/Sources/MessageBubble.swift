import SwiftUI
import Types

public struct MessageBubble: View {
    private let message: Message
    private let isCurrentUser: Bool
    
    public init(message: Message, isCurrentUser: Bool) {
        self.message = message
        self.isCurrentUser = isCurrentUser
    }
    
    public var body: some View {
        HStack {
            if isCurrentUser {
                Spacer()
            }
            VStack {
                Text(message.text)
                    .font(Fonts.small)
                    .foregroundStyle(.black)
                    .padding(10)
            }
            .background {
                RoundedRectangle(cornerRadius: Constants.corner)
                    .foregroundColor(isCurrentUser ? Color(.message) : Color(.light))
            }
            .padding(isCurrentUser ? .leading : .trailing, 30)
            if !isCurrentUser {
                Spacer()
            }
        }
    }
}
