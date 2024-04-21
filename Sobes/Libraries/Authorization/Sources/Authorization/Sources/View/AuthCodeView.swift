//
//  SwiftUIView.swift
//  
//
//  Created by Алиса Вышегородцева on 19.04.2024.
//

import SwiftUI
import UIComponents

struct AuthCodeView<Model:LoginViewModel>: View {
    @ObservedObject private var model: Model
    @State private var input: String = ""
    @State private var inputState: TextFieldView.InputState = .correct
    @State private var present: Bool = false

    public init(model: Model) {
        self._model = ObservedObject(wrappedValue: model)
    }
    
    
    public var body: some View {
        VStack(alignment: .leading) {
            back
            VStack(alignment: .leading, spacing: 16) {
                Text("Код")
                    .font(Font.custom("CoFoSans-Bold", size: 23))
                    .foregroundColor(.black)
                Text("На вашу электронную почту было отправлено письмо с кодом подтверждения")
                    .font(Font.custom("CoFoSans-Regular", size: 17))
                    .foregroundColor(.black)
                TextFieldView(model: .code, input: $input, inputState: $inputState)
                HStack {
                    Spacer()
                    repeatCode
                }
            }
            .padding(.top, 20)
            Spacer()
            button
            
        }
        .padding(.horizontal, 31)
        .padding(.bottom, 53)
    }
    
    var button: some View {
        MainButton(action: {
            if model.validateCode(code: input) {
                present = true
            } else {
                //TODO: прописать некорректный данный блять короче вы поняли
            }
        }, label: "Дальше")
            .navigationDestination(isPresented: $present) {
                    AuthNewPasswordView(model: model)
                        .navigationBarBackButtonHidden()
            }
    }
    
    var back: some View {
        BackButton(onTap: {})
    }
    
    var repeatCode: some View {
        Button(action: {
            model.sendCodeToEmail(email: input)
        }) {
            Text("отправить повторно")
                .foregroundColor(Color(.accent))
                .font(Font.custom("CoFoSans-Regular", size: 13))
        }
    }
}

