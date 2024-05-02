import SwiftUI
import UIComponents

struct AuthPasswordRecreateView<Model: AuthViewModel>: View {

    public init(model: Model) {
        self._model = ObservedObject(wrappedValue: model)
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            BackButton()
            VStack(alignment: .leading, spacing: Constants.defSpacing) {
                Text("Восстановление пароля")
                    .font(Fonts.heading)
                    .foregroundColor(.black)
                TextFieldView(model: .email, input: $inputEmail, inputState: $inputEmailState)
                Spacer()
                button
            }
            .padding(.top, Constants.topPadding)
        }
        .padding(.horizontal, Constants.horizontal)
        .padding(.bottom, Constants.bottom)
    }
    
    private var button: some View {
        MainButton(action: {
            model.sendCodeResetPassword(email: inputEmail)
            presentCode = true
        }, label: "Дальше")
            .navigationDestination(isPresented: $presentCode) {
               AuthCodeView(model: model)
                    .navigationBarBackButtonHidden()
            }
    }

    @ObservedObject private var model: Model

    @State private var inputEmail: String = ""
    @State private var inputEmailState: TextFieldView.InputState = .correct

    @State private var presentCode: Bool = false


}
