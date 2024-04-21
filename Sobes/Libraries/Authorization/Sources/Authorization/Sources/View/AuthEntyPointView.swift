//
//  SwiftUIView.swift
//  
//
//  Created by Алиса Вышегородцева on 19.04.2024.
//

import SwiftUI
import UIComponents

public struct AuthEntyPointView<Model: LoginViewModel>: View {
    @ObservedObject private var model: Model
    
    @State private var inputEmail: String = ""
    @State private var inputEmailState: TextFieldView.InputState = .correct
    
    @State private var inputPass: String = ""
    @State private var inputPassState: TextFieldView.InputState = .correct
    
    @State private var presentMain: Bool = false
    @State private var presentPasswordRecreate: Bool = false
    
    public init(model: Model) {
        self._model = ObservedObject(wrappedValue: model)
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            back
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
                button
            }
            .padding(.top, Constants.topPadding)
        }
        .padding(.horizontal, Constants.horizontal)
        .padding(.bottom, Constants.bottom)
    }
    
    var forgotPasswordButton: some View {
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
    
    var button: some View {
        MainButton(action: {
            presentMain = true
            model.onLoginTap()
        }, label: "Войти")
    }
    
    var back: some View {
        BackButton(onTap: {})
    }
}
