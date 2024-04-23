import SwiftUI
import Authorization
import Profile
import Chats
import UIComponents
import Materials
import Interview

public struct MainView: View {

    @State private var showTabBar = true
    @Binding var isAuthorized: Bool
    @Binding var selectedTab: TabItem

    public var body: some View {
        VStack {
            switch selectedTab {
            case .materials:
                MaterialsView(model: MaterialsViewModelImpl())
            case .interview:
                InterviewEntryPointView(model: InterviewViewModelImpl())
            case .chat:
                ChatsView(showTabBar: $showTabBar, model: ChatViewModelImpl(profileId: 0))
            case .profile:
                ProfileView(
                    model: ProfileViewModelImpl(
                        onLogoutAction: {
                            isAuthorized = false
                        }
                    ),
                    showTabBar: $showTabBar
                )
            }
            Spacer()
            if showTabBar {
                TabBar(selectedTab: $selectedTab)
            }
        }
    }

}
