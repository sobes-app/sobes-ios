import SwiftUI
import Types

public struct FilterBubble: View {

    public init(filter: Filter) {
        self.filter = filter
    }

    public var body: some View {
        Text(filter.name)
            .font(Font.custom("CoFoSans-Regular", size: 17))
            .foregroundStyle(filter.isActive ? .white : Color(.grey))
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(filter.isActive ? Color(.accent) : Color(.bubble))
            }
    }

    private var filter: Filter

}
