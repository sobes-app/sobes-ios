//
//  SwiftUIView.swift
//  
//
//  Created by Алиса Вышегородцева on 19.04.2024.
//

import SwiftUI
import UIComponents

public struct AuthEntyPointView: View {
    @State private var inputEmail: String = ""
    @State private var inputEmailState: TextFieldView.InputState = .correct
    
    @State private var inputPass: String = ""
    @State private var inputPassState: TextFieldView.InputState = .correct
    
    @State private var presentMain: Bool = false
    @State private var presentPasswordRecreate: Bool = false
    
    public init() { }
    
    public var body: some View {
        VStack(alignment: .leading) {
            back
            VStack(alignment: .leading, spacing: 16) {
                Text("Вход в аккаунт")
                    .font(Font.custom("CoFoSans-Bold", size: 23))
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
            .padding(.top, 20)
        }
        .padding(.horizontal, 31)
        .padding(.bottom, 53)
    }
    
    var forgotPasswordButton: some View {
        Button(action: {presentPasswordRecreate = true}) {
            Text("забыл пароль")
                .font(Font.custom("CoFoSans-Regular", size: 13))
                .foregroundColor(Color(.accent))
        }
        .navigationDestination(isPresented: $presentPasswordRecreate) {
            AuthPasswordRecreateView()
                .navigationBarBackButtonHidden()
        }
    }
    
    var button: some View {
        MainButton(action: {presentMain = true}, label: "Войти")
            .navigationDestination(isPresented: $presentMain) {
                //TODO: на главную
//                RegCodeView()
//                    .navigationBarBackButtonHidden()
            }
    }
    
    var back: some View {
        BackButton()
    }
}

#Preview {
    AuthEntyPointView()
}
