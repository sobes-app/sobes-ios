import SwiftUI

public struct ErrorView: View {

    public init(retryAction: @escaping () -> Void) {
        self.action = retryAction
    }

    public var body: some View {
        VStack(spacing: Constants.defSpacing) {
            Spacer()
            Text("Что-то пошло не так")
                .font(Fonts.main)
                .foregroundStyle(.black)
            Button {
                action()
            } label: {
                Image(systemName: "arrow.circlepath")
                    .foregroundStyle(.white)
                    .bold()
            }
            .buttonStyle(ScaleButtonStyle())
            .padding(Constants.elementPadding)
            .background(Color(.accent))
            .clipShape(Circle())
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(.white)
    }

    private let action: () -> Void

}
