import SwiftUI
import UIComponents

struct AuthCodeView<Model:LoginViewModel>: View {
    @ObservedObject private var model: Model
    @State private var input: String = ""
    @State private var inputState: TextFieldView.InputState = .correct
    @State private var present: Bool = false

    public init(model: Model) {
        self._model = ObservedObject(wrappedValue: model)
    }
    
    
    public var body: some View {
        VStack(alignment: .leading) {
            BackButton()
            VStack(alignment: .leading, spacing: Constants.defSpacing) {
                Text("Код")
                    .font(Fonts.heading)
                    .foregroundColor(.black)
                Text("На вашу электронную почту было отправлено письмо с кодом подтверждения")
                    .font(Fonts.main)
                    .foregroundColor(.black)
                TextFieldView(model: .code, input: $input, inputState: $inputState)
                HStack {
                    Spacer()
                    repeatCode
                }
            }
            .padding(.top, Constants.topPadding)
            Spacer()
            button
            
        }
        .padding(.horizontal, Constants.horizontal)
        .padding(.bottom, Constants.bottom)
    }
    
    var button: some View {
        MainButton(action: {
            if model.validateCode(code: input) {
                present = true
            } else {
                //TODO: прописать некорректный данный блять короче вы поняли
            }
        }, label: "Дальше")
            .navigationDestination(isPresented: $present) {
                    AuthNewPasswordView(model: model)
                        .navigationBarBackButtonHidden()
            }
    }
    
    var repeatCode: some View {
        Button(action: {
            model.sendCodeToEmail(email: input)
        }) {
            Text("отправить повторно")
                .foregroundColor(Color(.accent))
                .font(Fonts.small)
        }
    }
}

