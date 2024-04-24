import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
    }
}

public struct MainButton: View {

    public init(action: @escaping @MainActor () -> Void, label: String) {
        self.action = action
        self.label = label
    }

    public var body: some View {
        Button (action: action) {
            Text(label)
                .bold()
                .font(Fonts.mainBold)
                .foregroundColor(.white)
                .padding(.vertical, Constants.elementPadding)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: Constants.corner)
                        .foregroundColor(Color(.accent))
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                }
            
        }
        .buttonStyle(ScaleButtonStyle())
        .padding(.horizontal, 20)
    }

    private let action: @MainActor () -> Void
    private let label: String

}
