import SwiftUI
import Authorization
import UIComponents
import Providers

struct ContentView: View {
    @StateObject var auth = Authentication()
    
    init() {
        self.selectedTab = .materials
        self.profileProvider = ProfileProviderImpl()
    }
    
    var body: some View {
        MainView(selectedTab: $selectedTab,
                 profileProvider: profileProvider)
        .environmentObject(auth)
        .overlay {
            if !auth.isAuth {
                EntryPointView(
                    selectedTab: $selectedTab,
                    provider: profileProvider
                ).environmentObject(auth)
            }
        }
    }
    
    @State private var selectedTab: TabItem
    let profileProvider: ProfileProvider
}

#Preview {
    ContentView()
}
