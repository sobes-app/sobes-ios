import SwiftUI

public struct LoadingScreen: View {

    public init(placeholder: String) {
        self.placeholder = placeholder
    }

    public var body: some View {
        VStack(spacing: Constants.defSpacing) {
            Spacer()
            if isViewAvailable {
                ProgressView()
                Text(placeholder)
                    .font(Fonts.main)
                    .foregroundStyle(Color(.lightGray))
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background {
            Color(.white)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isViewAvailable = true
            }
        }
    }

    private let placeholder: String
    @State private var isViewAvailable: Bool = false

}
