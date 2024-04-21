import SwiftUI
import Authorization
import Profile
import Chats
import UIComponents
import Materials

public struct MainView: View {

    @State var selectedTab: TabItem = .profile
    @State private var showTabBar = true
    @Binding var isAuthorized: Bool

    public var body: some View {
        VStack {
            switch selectedTab {
            case .materials:
                MaterialsView(model: MaterialsViewModelImpl())
                    .ignoresSafeArea()
                    .background(.white)
            case .interview:
                VStack {
                    Text("o guys")
                    Spacer()
                    Text("a")
                }
            case .chat:
                ChatsView(showTabBar: $showTabBar, model: ChatViewModelImpl(profileId: 0))
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
