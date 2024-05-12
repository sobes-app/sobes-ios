import SwiftUI
import UIComponents

struct RegFinalView<Model: AuthViewModel>: View {
    @EnvironmentObject var auth: Authentication
    @StateObject private var authVM = PasswordViewModel()

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
                    TextFieldView(model: .password, input: $authVM.password, passwordText: "введите пароль...")
                    passwordCheckBoxes
                    TextFieldView(model: .password, input: $authVM.confirmPassword, passwordText: "повторите пароль...")
                    confirmPasswordCheckBox
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
    
    var passwordCheckBoxes: some View {
        VStack(alignment: .leading) {
            checkBox(toggled: $authVM.hasEightChar, text: "Содержит 8 символов")
            checkBox(toggled: $authVM.hasOneDigit, text: "Содержит 1 цифру")
            checkBox(toggled: $authVM.hasOneUpperCaseChar, text: "Содержит 1 заглавную букву")
        }
    }
    
    var confirmPasswordCheckBox: some View {
        checkBox(toggled: $authVM.confirmationMatch, text: "Пароли совпадают")
    }
    
    @ViewBuilder
    func checkBox(toggled: Binding<Bool>, text: String) -> some View {
        HStack {
            Circle()
                .stroke()
                .foregroundColor(.black)
                .frame(width: 25)
                .background {
                    if toggled.wrappedValue {
                        Image(systemName: "chevron.down")
                            .frame(width: 17, height: 17)
                            .accentColor(.black)
                    } else {
                        
                    }
                }
            Text(text)
                .font(Fonts.small)
                .foregroundColor(.black)
        }
    }
    
    var button: some View {
        MainButton(
            action: {
                if inputName.isEmpty {
                    message = "введите имя"
                    showIncorrect()
                } else if !$authVM.areAllFieldsValid.wrappedValue {
                    message = "пароль не соответствует требованиям"
                    showIncorrect()
                } else if !$authVM.confirmationMatch.wrappedValue {
                    message = "пароли не совпадают"
                    showIncorrect()
                } else {
                    Task { @MainActor in
                        if !(await model.registerUser(email: model.email, username: inputName, password: inputPassword)) {
                            auth.updateStatus(success: false)
                            message = "Возникла ошибка при регистрации"
                            showIncorrect()
                        } else {
                            auth.updateStatus(success: true)
                        }
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

