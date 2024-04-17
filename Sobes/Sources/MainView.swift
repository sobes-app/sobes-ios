import SwiftUI
import UIComponents

struct MainView: View {

    @State var selectedTab: TabItem = .materials

    var body: some View {
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
                VStack {
                    Text("Hi guys")
                    Spacer()
                    Text("Buy")
                }
            }

            Spacer()
            TabBar(selectedTab: $selectedTab)
        }
    }

}
