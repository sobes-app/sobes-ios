import SwiftUI
import UIComponents
import Authorization
import Profile
import Chats

public struct MainView: View {

    @State var selectedTab: TabItem = .profile
    @State private var showTabBar = true
    @Binding var isAuthorized: Bool

    public var body: some View {
        VStack {
            switch selectedTab {
            case .materials:
                VStack {
                    Text("Hi guys")
                    Spacer()
                    Text("Buy")
                }
            case .interview:
                VStack {
                    Text("o guys")
                    Spacer()
                    Text("a")
                }
            case .chat:
                ChatsView(showTabBar: $showTabBar)
            case .profile:
                ProfileView(model: ProfileViewModelImpl(onLogoutAction: {
                    isAuthorized = false
                }), showTabBar: $showTabBar)
            }

            Spacer()
            if showTabBar {
                TabBar(selectedTab: $selectedTab)
            }
        }
    }

}
