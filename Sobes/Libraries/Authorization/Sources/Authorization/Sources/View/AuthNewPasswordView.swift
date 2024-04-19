//
//  SwiftUIView.swift
//  
//
//  Created by Алиса Вышегородцева on 19.04.2024.
//

import SwiftUI
import UIComponents

struct AuthNewPasswordView: View {
    @State private var inputPassword: String = ""
    @State private var inputPasswordState: TextFieldView.InputState = .correct
    
    @State private var inputRep: String = ""
    @State private var inputRepState: TextFieldView.InputState = .correct
    
    @State private var presentProfile: Bool = false
        
    public var body: some View {
        VStack(alignment: .leading) {
            back
            VStack(alignment: .leading, spacing: 16){
                Text("Восстановление пароля")
                    .font(Font.custom("CoFoSans-Bold", size: 23))
                    .foregroundColor(.black)
                TextFieldView(model: .password, input: $inputPassword, inputState: $inputPasswordState)
                TextFieldView(model: .repPassword, input: $inputRep, inputState: $inputRepState)
                Spacer()
                button
            }
            .padding(.top, 20)
        }
        .padding(.horizontal, 31)
        .padding(.bottom, 53)
    }
    
    var button: some View {
        MainButton(action: {presentProfile = true}, label: "Войти")
            .navigationDestination(isPresented: $presentProfile) {
                //TODO: авторизировался, надо перейти на главную
            }
    }
    
    var back: some View {
        BackButton()
    }
}

#Preview {
    AuthNewPasswordView()
}
