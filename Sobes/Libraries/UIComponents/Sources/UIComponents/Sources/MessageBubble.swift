import SwiftUI
import Types

public struct MessageBubble: View {
    private let message: Message
    private let isCurrentUser: Bool
    
    public init(message: Message, isCurrentUser: Bool) {
        self.message = message
        self.isCurrentUser = isCurrentUser
    }
    
    func convertDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let timeString = dateFormatter.string(from: date)
        return timeString
    }
    
    public var body: some View {
        HStack {
            if isCurrentUser {
                Spacer()
            }
            VStack {
                VStack(alignment: .trailing) {
                    Text(message.text)
                        .font(Fonts.small)
                        .foregroundStyle(.black)
                    Text(convertDate(date: message.date))
                        .font(.system(size: 10))
                        .foregroundStyle(.gray)
                    
                }
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
