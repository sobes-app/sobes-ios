import SwiftUI
import UIComponents

public struct RegEmailView<Model: RegistrationViewModel>: View {
    @ObservedObject private var model: Model
    
    @State private var input: String = ""
    @State private var inputState: TextFieldView.InputState = .correct
    @State private var presentCode: Bool = false
    
    public init(model: Model) {
        self._model = ObservedObject(wrappedValue: model)
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            back
            VStack(alignment: .leading, spacing: Constants.defSpacing) {
                Text("Поехали!")
                    .font(Fonts.heading)
                    .foregroundColor(.black)
                TextFieldView(model: .email, input: $input, inputState: $inputState)
                Spacer()
                button
            }
            .padding(.top, Constants.topPadding)
        }
        .padding(.horizontal, Constants.horizontal)
        .padding(.bottom, Constants.bottom)
    }
    
    var button: some View {
        MainButton(action: {
            presentCode = true
            model.sendCodetoEmail(email: input)
        }, label: "Дальше")
            .navigationDestination(isPresented: $presentCode) {
                RegCodeView(model: model)
                    .navigationBarBackButtonHidden()
            }
    }
    
    var back: some View {
        BackButton(onTap: {})
    }
}
