import SwiftUI
import UIComponents
import Authorization

public struct MainView: View {

    @State var selectedTab: TabItem = .profile
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
                VStack {
                    Text("Hi guys")
                    Spacer()
                    Text("Buy")
                }
            case .profile:
                ProfileView()
            }

            Spacer()
            TabBar(selectedTab: $selectedTab)
        }
    }

}
