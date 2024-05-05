import SwiftUI
import Authorization
import Profile
import Chats
import UIComponents
import Materials
import Providers
import Interview
import Types

public struct MainView: View {
    
    @EnvironmentObject var auth: Authentication
    @Binding var selectedTab: TabItem
    let profileProvider: ProfileProvider

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
                        ), 
                        profileProvider: profileProvider
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

    @State private var showTabBar = true

}
