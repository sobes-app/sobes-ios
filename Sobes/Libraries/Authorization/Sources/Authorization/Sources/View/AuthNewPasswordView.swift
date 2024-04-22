//
//  SwiftUIView.swift
//  
//
//  Created by Алиса Вышегородцева on 19.04.2024.
//

import SwiftUI
import UIComponents

struct AuthNewPasswordView<Model: LoginViewModel>: View {
    
    public init(model: Model) {
        self._model = ObservedObject(wrappedValue: model)
    }
            
    public var body: some View {
        VStack(alignment: .leading) {
            BackButton()
            VStack(alignment: .leading, spacing: Constants.defSpacing){
                Text("Восстановление пароля")
                    .font(Fonts.heading)
                    .foregroundColor(.black)
                TextFieldView(model: .password, input: $inputPassword, inputState: $inputPasswordState)
                TextFieldView(model: .repPassword, input: $inputRep, inputState: $inputRepState)
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
            if !model.updatePassword(newPassword: inputPassword, repeatPassword: inputRep) {
                //TODO: обработка некорректности
            }
        }, label: "Войти")
    }

    @ObservedObject private var model: Model

    @State private var inputPassword: String = ""
    @State private var inputPasswordState: TextFieldView.InputState = .correct

    @State private var inputRep: String = ""
    @State private var inputRepState: TextFieldView.InputState = .correct
    
}
