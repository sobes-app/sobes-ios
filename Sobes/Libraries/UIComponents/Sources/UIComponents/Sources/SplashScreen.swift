import SwiftUI

public struct SplashScreen: View {

    public init() {}

    public var body: some View {
        ZStack {
            Color.white.opacity(0.6).edgesIgnoringSafeArea(.all)
        }
        ProgressView()
    }

}
