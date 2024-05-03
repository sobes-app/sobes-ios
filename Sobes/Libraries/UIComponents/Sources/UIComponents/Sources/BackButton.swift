import SwiftUI
import Toolbox

public struct BackButton: View {
    
    public init(onTap: (() -> Void)? = nil) {
        self.onTap = onTap
    }
    
    public var body: some View {
        Button(action: {
            if onTap != nil {
                onTap?()
            } else {
                withoutAnimation {
                    presentationMode.wrappedValue.dismiss()
                }
            }
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

	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    private let onTap: (() -> Void)?

}
