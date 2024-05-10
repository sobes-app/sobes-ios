import SwiftUI
import UIComponents

struct RegFinalView<Model: AuthViewModel>: View {
    @EnvironmentObject var auth: Authentication

    public init(model: Model) {
        self._model = ObservedObject(wrappedValue: model)
    }
        
    public var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                BackButton()
                VStack(alignment: .leading, spacing: Constants.defSpacing){
                    Text("Почти закончили!")
                        .font(Fonts.heading)
                        .foregroundColor(.black)
                    TextFieldView(model: .name, input: $inputName)
                    TextFieldView(model: .password, input: $inputPassword, passwordText: "введите пароль...")
                    TextFieldView(model: .password, input: $inputRep, passwordText: "повторите пароль...")
                    Spacer()
                    VStack {
                        if incorrect {
                            IncorrectView(text: message)
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
    
    var button: some View {
        MainButton(
            action: {
                if inputPassword != inputRep {
                    message = "Пароли не совпадают"
                    showIncorrect()
                }
                Task { @MainActor in
                    if !(await model.registerUser(email: model.email, username: inputName, password: inputPassword)) {
                        auth.updateStatus(success: false)
                        message = "Возникла ошибка при регистрации"
                        showIncorrect()
                    } else {
                        auth.updateStatus(success: true)
                    }
                }
            },
            label: "Зарегистрироваться"
        )
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

    @State private var inputName: String = ""
    @State private var inputPassword: String = ""
    @State private var inputRep: String = ""

    @State private var message: String = ""
    @State private var incorrect: Bool = false

}

