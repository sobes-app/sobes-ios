import SwiftUI
import UIComponents

public struct RegEmailView: View {
    @State private var input: String = ""
    @State private var inputState: TextFieldView.InputState = .correct
    @State private var presentCode: Bool = false
    
    public init() { }
    
    public var body: some View {
        VStack(alignment: .leading) {
            back
            VStack(alignment: .leading, spacing: 16) {
                Text("Поехали!")
                    .font(Font.custom("CoFoSans-Bold", size: 23))
                    .foregroundColor(.black)
                TextFieldView(model: .email, input: $input, inputState: $inputState)
                Spacer()
                button
            }
            .padding(.top, 20)
        }
        .padding(.horizontal, 31)
        .padding(.bottom, 53)
    }
    
    var button: some View {
        MainButton(action: {presentCode = true}, label: "Дальше")
            .navigationDestination(isPresented: $presentCode) {
                RegCodeView(from: .register)
                    .navigationBarBackButtonHidden()
            }
    }
    
    var back: some View {
        BackButton()
    }
}

#Preview {
    RegEmailView()
}
