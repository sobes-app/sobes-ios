//
//  SwiftUIView.swift
//  
//
//  Created by Алиса Вышегородцева on 30.04.2024.
//

import SwiftUI
import Foundation
import UIComponents
import Authorization

struct ChangePasswordView<Model: ProfileViewModel>: View {
    public init(model: Model) {
        self._model = ObservedObject(wrappedValue: model)
    }
            
    public var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                BackButton()
                VStack(alignment: .leading, spacing: Constants.defSpacing){
                    Text("Смена пароля")
                        .font(Fonts.heading)
                        .foregroundColor(.black)
                    TextFieldView(model: .password, input: $inputPassword, passwordText: "старый пароль...")
                    TextFieldView(model: .password, input: $inputNew, passwordText: "новый пароль...")
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
    
    private var button: some View {
        MainButton(action: {
            if inputNew != inputRep {
                message = "пароли не совпадают"
                showIncorrect()
            }
            Task { @MainActor in
                let success = await model.changePassword(oldPassword: inputPassword, newPassword: inputNew)
                if success {
                    presentationMode.wrappedValue.dismiss()
                } else {
                    message = "ошибка при смене пароля"
                    showIncorrect()
                }
            }
        }, label: "Сменить пароль")
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

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject private var model: Model

    @State private var inputPassword: String = ""
    @State private var inputNew: String = ""
    @State private var inputRep: String = ""
    
    @State var incorrect: Bool = false
    @State var message: String = "ошибка при смене пароля"
}
