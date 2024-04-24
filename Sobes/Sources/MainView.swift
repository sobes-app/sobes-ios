import SwiftUI
import Authorization
import Profile
import Chats
import UIComponents
import Materials
import Providers
import Interview

public struct MainView: View {

    @State private var showTabBar = true
    @Binding var isAuthorized: Bool
    @Binding var selectedTab: TabItem
    
    public init(isAuthorized: Binding<Bool>, selectedTab: Binding<TabItem>) {
        self._isAuthorized = isAuthorized
        self._selectedTab = selectedTab
        profileProvider = ProfileProviderImpl()
        chatProvider = ChatsProviderImpl(profileProvider: profileProvider)
    }

    public var body: some View {
        VStack {
            switch selectedTab {
            case .materials:
                MaterialsView(model: MaterialsViewModelImpl(materialsProvider: materialsProvider))
            case .interview:
                InterviewEntryPointView(model: InterviewViewModelImpl(questionsProvider: questionsProvider))
            case .chat:
                ChatsView(showTabBar: $showTabBar, model: ChatViewModelImpl(profileProvider: profileProvider, chatProvider: chatProvider))
            case .profile:
                ProfileView(model: ProfileViewModelImpl(onLogoutAction: {
                    isAuthorized = false
                }, profileProvider: profileProvider), showTabBar: $showTabBar)
            }
            Spacer()
            if showTabBar {
                TabBar(selectedTab: $selectedTab)
            }
        }
    }
    
    let profileProvider: ProfileProvider
    let chatProvider: ChatsProvider
    let materialsProvider: MaterialsProvider = MaterialsProviderImpl()
    let questionsProvider: QuestionsProvider = QuestionsProviderImpl()

}
