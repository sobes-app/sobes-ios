import SwiftUI
import Types

public enum MessageType {
    case selfMessage
    case responder
}

public struct MessageBubble: View {
    private let message: Message
    private let type: MessageType
    
    public init(message: Message, type: MessageType) {
        self.message = message
        self.type = type
    }
    
    public var body: some View {
        HStack {
            if type == .selfMessage {
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
                    .foregroundColor(type == .selfMessage ? Color(.message) : Color(.light))
            }
            if type == .responder {
                Spacer()
            }
        }
    }
}
