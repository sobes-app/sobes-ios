import SwiftUI

public struct FilterBubble: View {

    @Binding var tapped: Bool
    var text: String

    public init(tapped: Binding<Bool>, text: String) {
        self._tapped = tapped
        self.text = text
    }

    public var body: some View {
        Text(text)
            .font(Font.custom("CoFoSans-Regular", size: 17))
            .foregroundStyle(tapped ? .white : Color(.secondary))
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(tapped ? Color(.accent) : Color(.bubble))
            }
    }
}
