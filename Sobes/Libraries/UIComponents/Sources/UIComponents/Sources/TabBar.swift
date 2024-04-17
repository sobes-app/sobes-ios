import SwiftUI

public struct TabBar: View {

    @Binding var selectedTab: TabItem

    public init(selectedTab: Binding<TabItem>) {
        self._selectedTab = selectedTab
    }

    public var body: some View {
        HStack(spacing: 47) {
            Button {
                selectedTab = .materials
            } label : {
                Image(systemName: TabItem.materials.iconName)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 17, height: 27)
                    .foregroundStyle(selectedTab == .materials ? .white : Color(.lightsecondary))
            }

            Button {
                selectedTab = .interview
            } label : {
                Image(systemName: TabItem.interview.iconName)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundStyle(selectedTab == .interview ? .white : Color(.lightsecondary))
            }

            Button {
                selectedTab = .chat
            } label : {
                Image(systemName: TabItem.chat.iconName)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundStyle(selectedTab == .chat ? .white : Color(.lightsecondary))
            }

            Button {
                selectedTab = .profile
            } label : {
                Image(systemName: TabItem.profile.iconName)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundStyle(selectedTab == .profile ? .white : Color(.lightsecondary))
            }
        }
        .ignoresSafeArea(.keyboard)
        .frame(height: 80)
        .frame(maxWidth: .infinity)
        .background(Color(.secondary))
    }

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
