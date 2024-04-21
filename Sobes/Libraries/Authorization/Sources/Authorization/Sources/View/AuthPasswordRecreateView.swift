//
//  SwiftUIView.swift
//  
//
//  Created by Алиса Вышегородцева on 19.04.2024.
//

import SwiftUI
import UIComponents

struct AuthPasswordRecreateView<Model: LoginViewModel>: View {
    @ObservedObject private var model: Model
    
    @State private var inputEmail: String = ""
    @State private var inputEmailState: TextFieldView.InputState = .correct
    
    @State private var presentCode: Bool = false
    
    public init(model: Model) {
        self._model = ObservedObject(wrappedValue: model)
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            back
            VStack(alignment: .leading, spacing: 16) {
                Text("Восстановление пароля")
                    .font(Font.custom("CoFoSans-Bold", size: 23))
                    .foregroundColor(.black)
                TextFieldView(model: .email, input: $inputEmail, inputState: $inputEmailState)
                Spacer()
                button
            }
            .padding(.top, 20)
        }
        .padding(.horizontal, 31)
        .padding(.bottom, 53)
    }
    
    var button: some View {
        MainButton(action: {
            model.sendCodeToEmail(email: inputEmail)
            presentCode = true
        }, label: "Дальше")
            .navigationDestination(isPresented: $presentCode) {
               AuthCodeView(model: model)
                    .navigationBarBackButtonHidden()
            }
    }
    
    var back: some View {
        BackButton(onTap: {})
    }
}
