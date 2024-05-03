import SwiftUI
import UIComponents

struct AuthPasswordRecreateView<Model: AuthViewModel>: View {
    @EnvironmentObject var auth: Authentication
    
    public init(model: Model) {
        self._model = ObservedObject(wrappedValue: model)
    }
    
    public var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                BackButton()
                VStack(alignment: .leading, spacing: Constants.defSpacing) {
                    Text("Восстановление пароля")
                        .font(Fonts.heading)
                        .foregroundColor(.black)
                    TextFieldView(model: .email, input: $inputEmail, inputState: $inputEmailState)
                    Spacer()
                    VStack {
                        if incorrect {
                            IncorrectView(text: "неверная почта")
                        }
                        button
                    }
                }
                .padding(.top, Constants.topPadding)
            }
            .padding(.horizontal, Constants.horizontal)
            .padding(.bottom, Constants.bottom)
            
            if model.isLoading {
                SplashScreen()
            }
        }
    }
    
    private var button: some View {
        MainButton(action: {
            Task { @MainActor in
                let success = await model.sendCodeResetPassword(email: inputEmail)
                if success {
                    presentCode = true
                } else {
                    showIncorrect()
                }
            }
        }, label: "Дальше")
            .navigationDestination(isPresented: $presentCode) {
               AuthCodeView(model: model)
                    .navigationBarBackButtonHidden()
                    .environmentObject(auth)
            }
    }
    
    func showIncorrect() {
        withAnimation {
            incorrect = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            withAnimation {
                incorrect = false
            }
        })
    }

    @ObservedObject private var model: Model

    @State private var inputEmail: String = ""
    @State private var inputEmailState: TextFieldView.InputState = .correct

    @State private var presentCode: Bool = false
    @State private var incorrect: Bool = false


}
