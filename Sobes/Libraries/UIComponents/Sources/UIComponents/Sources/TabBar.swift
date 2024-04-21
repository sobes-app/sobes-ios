import SwiftUI

public struct TabBar: View {

    public init(selectedTab: Binding<TabItem>) {
        self._selectedTab = selectedTab
    }

    public var body: some View {
        HStack(spacing: 55) {
            Button {
                selectedTab = .materials
            } label : {
                Image(systemName: TabItem.materials.iconName)
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 24)
                    .foregroundStyle(selectedTab == .materials ? .white : Color(.light))
            }

            Button {
                selectedTab = .interview
            } label : {
                Image(systemName: TabItem.interview.iconName)
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 24)
                    .foregroundStyle(selectedTab == .interview ? .white : Color(.light))
            }

            Button {
                selectedTab = .chat
            } label : {
                Image(systemName: TabItem.chat.iconName)
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 24)
                    .foregroundStyle(selectedTab == .chat ? .white : Color(.light))
            }

            Button {
                selectedTab = .profile
            } label : {
                Image(systemName: TabItem.profile.iconName)
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 24)
                    .foregroundStyle(selectedTab == .profile ? .white : Color(.light))
            }
        }
        .ignoresSafeArea(.keyboard)
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(Color("grey", bundle: .module))
    }

    @Binding private var selectedTab: TabItem

}

public enum TabItem: Int, CaseIterable {
    case materials = 0
    case interview
    case chat
    case profile

    var iconName: String {
        switch self {
        case .materials:
            return "bolt.fill"
        case .interview:
            return "book.fill"
        case .chat:
            return "bubble.fill"
        case .profile:
            return "person.fill"
        }
    }
}
