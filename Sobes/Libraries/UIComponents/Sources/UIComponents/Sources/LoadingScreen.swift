import SwiftUI

public struct LoadingScreen: View {

    public init(placeholder: String) {
        self.placeholder = placeholder
    }

    public var body: some View {
        VStack(spacing: Constants.defSpacing) {
            Spacer()
            ProgressView()
            Text(placeholder)
                .font(Fonts.main)
                .foregroundStyle(Color(.lightGray))
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background {
            Color(.white)
        }
    }

    private let placeholder: String

}
