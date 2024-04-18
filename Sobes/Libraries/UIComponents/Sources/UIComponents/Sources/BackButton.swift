import SwiftUI

public struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    public init() {
    }

    public var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.backward")
                .frame(width: 28, height: 28)
                .foregroundColor(.black)
                .padding(15)
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(.light))
        }
    }
}
