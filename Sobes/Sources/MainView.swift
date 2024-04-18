import SwiftUI
import Authorization
import Profile
import UIComponents
import Materials

public struct MainView: View {

    @State var selectedTab: TabItem = .profile
    @Binding var isAuthorized: Bool

    public var body: some View {
        VStack {
            switch selectedTab {
            case .materials:
                MaterialsView(model: MaterialsViewModelImpl())
            case .interview:
                VStack {
                    Text("o guys")
                    Spacer()
                    Text("a")
                }
            case .chat:
                VStack {
                    Text("Hi guys")
                    Spacer()
                    Text("Buy")
                }
            case .profile:
                ProfileView(model: ProfileViewModelImpl(onLogoutAction: {
                    isAuthorized = false
                }))
            }

            Spacer()
            TabBar(selectedTab: $selectedTab)
        }
    }

}
