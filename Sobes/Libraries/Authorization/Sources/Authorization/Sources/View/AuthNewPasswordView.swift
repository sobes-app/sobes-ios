//
//  SwiftUIView.swift
//  
//
//  Created by Алиса Вышегородцева on 19.04.2024.
//

import SwiftUI
import UIComponents

struct AuthNewPasswordView<Model: AuthViewModel>: View {
    @EnvironmentObject var auth: Authentication
    
    public init(model: Model) {
        self._model = ObservedObject(wrappedValue: model)
    }
            
    public var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                BackButton()
                VStack(alignment: .leading, spacing: Constants.defSpacing){
                    Text("Восстановление пароля")
                        .font(Fonts.heading)
                        .foregroundColor(.black)
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
                ZStack {
                    SplashScreen()
                }
            }
        }
    }
    
    private var button: some View {
        MainButton(action: {
            if inputPassword != inputRep {
                message = "пароли не совпадают"
                showIncorrect()
            } else {
                Task { @MainActor in
                    let success = await model.updatePassword(password: inputPassword)
                    if success {
                        auth.updateStatus(success: true)
                    } else {
                        message = "ошибка при смене пароля"
                        showIncorrect()
                    }
                }
            }
        }, label: "Войти")
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

    @State private var inputPassword: String = ""
    @State private var inputRep: String = ""
    @State private var incorrect: Bool = false
    @State private var message: String = "ошибка смены пароля"
    
}
