import SwiftUI
import Authorization
import UIComponents

struct ContentView: View {
    
    init() {
        self._isAuthorized = State(initialValue: true)
        self.selectedTab = .materials
    }
    
    var body: some View {
        MainView(isAuthorized: $isAuthorized, selectedTab: $selectedTab)
            .overlay {
                if !isAuthorized {
                    EntryPointView(
                        isAuthorized: $isAuthorized,
                        selectedTab: $selectedTab
                    )
                }
            }
    }
    
    @State private var isAuthorized: Bool
    @State private var selectedTab: TabItem
}

#Preview {
    ContentView()
}
