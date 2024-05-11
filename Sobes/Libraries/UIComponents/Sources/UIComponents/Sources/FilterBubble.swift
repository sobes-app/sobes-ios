import SwiftUI
import Types

public struct FilterBubble: View {

    public enum FilterType {
        case main
        case secondary
    }

    public init(filter: Filter, type: FilterType = .main) {
        self.filter = filter
        self.type = type
    }

    public var body: some View {
        switch type {
        case .main:
            Text(filter.name)
                .font(Fonts.small)
                .foregroundStyle(filter.isActive ? .white : Color(.grey))
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: Constants.corner)
                        .foregroundStyle(filter.isActive ? Color(.accent) : Color(.bubble))
                }
        case .secondary:
            Text(filter.name)
                .font(Fonts.small)
                .foregroundStyle(filter.isActive ? .white : Color(.grey))
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: Constants.corner)
                        .foregroundStyle(filter.isActive ? Color(.accent) : Color(.bubble))
                }
        }

    }

    private let type: FilterType
    private let filter: Filter

}
