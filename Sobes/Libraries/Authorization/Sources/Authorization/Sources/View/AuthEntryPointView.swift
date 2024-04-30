import SwiftUI
import UIComponents

public struct AuthEntryPointView<Model: AuthViewModel>: View {
    @EnvironmentObject var auth: Authentication
    
    public init(model: Model) {
        self._model = StateObject(wrappedValue: model)
    }
    
    public var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                BackButton()
                VStack(alignment: .leading, spacing: Constants.defSpacing) {
                    Text("Вход в аккаунт")
                        .font(Fonts.heading)
                        .foregroundColor(.black)
                    TextFieldView(model: .email, input: $inputEmail, inputState: $inputEmailState)
                    TextFieldView(model: .password, input: $inputPass, inputState: $inputPassState)
                    HStack {
                        Spacer()
                        forgotPasswordButton
                    }
                    Spacer()
                    VStack {
                        if incorrect {
                            IncorrectView(text: "неверная почта или пароль")
                        }
                        button
                    }
                }
                .padding(.top, Constants.topPadding)
            }
        }
        .padding(.horizontal, Constants.horizontal)
        .padding(.bottom, Constants.bottom)
    }
    
    private var forgotPasswordButton: some View {
        Button(action: {presentPasswordRecreate = true}) {
            Text("забыл пароль")
                .font(Fonts.small)
                .foregroundColor(Color(.accent))
        }
        .navigationDestination(isPresented: $presentPasswordRecreate) {
            AuthPasswordRecreateView(model: model)
                .navigationBarBackButtonHidden()
        }
    }
    
    private var button: some View {
        MainButton(action: {
            if TextFieldValidator.isInputValid(.email(inputEmail)) && TextFieldValidator.isInputValid(.password(inputPass)) {
                Task { @MainActor in
                    if !(await model.onLoginTap(email: inputEmail, password: inputPass)) {
                        auth.updateStatus(success: false)
                        withAnimation {
                            incorrect = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            withAnimation {
                                incorrect = false
                            }
                        })
                    } else {
                        auth.updateStatus(success: true)
                    }
                }
            } else {
                withAnimation {
                    incorrect = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    withAnimation {
                        incorrect = false
                    }
                })
            }
        }, label: "Войти")
    }
    
    @StateObject private var model: Model
    
    @State private var inputEmail: String = ""
    @State private var inputEmailState: TextFieldView.InputState = .correct
    
    @State private var inputPass: String = ""
    @State private var inputPassState: TextFieldView.InputState = .correct
    
    @State private var presentMain: Bool = false
    @State private var presentPasswordRecreate: Bool = false
    
    @State private var incorrect: Bool = false
}
