import SwiftUI
import Authorization

struct ContentView: View {
    
    init() {
        self._isAuthorized = State(initialValue: false)
    }
    
    var body: some View {
        MainView(isAuthorized: $isAuthorized)
            .overlay {
                if !isAuthorized {
                    EntryPointView(isAuthorized: $isAuthorized)
                }
            }
    }
    
    @State var isAuthorized: Bool
}

#Preview {
    ContentView()
}
