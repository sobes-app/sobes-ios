import SwiftUI

public struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    private let onTap: () -> Void
    
    public init(onTap: @escaping () -> Void) {
        self.onTap = onTap
    }
    
    public var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
            onTap()
        }) {
            Image(systemName: "chevron.backward")
                .frame(width: 28, height: 28)
                .foregroundColor(.black)
                .padding(Constants.elementPadding)
        }
        .background {
            RoundedRectangle(cornerRadius: Constants.corner)
                .foregroundColor(Color(.light))
        }
    }
}
