import SwiftUI
import Authorization
import Profile
import Chats
import UIComponents
import Materials
import Providers
import Interview

public struct MainView: View {
    @EnvironmentObject var auth: Authentication

    @State private var showTabBar = true
    @Binding var selectedTab: TabItem

    public var body: some View {
        VStack {
            switch selectedTab {
            case .materials:
                MaterialsView(model: MaterialsViewModelImpl(materialsProvider: MaterialsProviderImpl()))
            case .interview:
                InterviewEntryPointView(
                    model: InterviewViewModelImpl(
                        questionsProvider: QuestionsProviderImpl(
                            profileProvider: profileProvider
                        )
                    )
                )
            case .chat:
                ChatsView(showTabBar: $showTabBar, model: ChatViewModelImpl(profileProvider: profileProvider, chatProvider: ChatsProviderImpl(profileProvider: profileProvider)))
            case .profile:
                ProfileView(model: ProfileViewModelImpl(profileProvider: profileProvider), showTabBar: $showTabBar)
                    .environmentObject(auth)
            }
            Spacer()
            if showTabBar {
                TabBar(selectedTab: $selectedTab)
            }
        }
    }
    
    let profileProvider: ProfileProvider
}
