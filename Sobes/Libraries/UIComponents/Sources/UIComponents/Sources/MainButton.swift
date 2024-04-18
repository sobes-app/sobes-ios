import SwiftUI

public struct MainButton: View {
    private let action: @MainActor () -> Void
    private let label: String

    public init(action: @escaping @MainActor () -> Void, label: String) {
        self.action = action
        self.label = label
    }

    public var body: some View {
        Button (action: action) {
            Text(label)
                .bold()
                .font(Font.custom("CoFoSans-Bold", size: 17))
                .foregroundColor(.white)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
            
        }.background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(.accent))
        }
        .padding(.horizontal, 20)
    }

}
