//
//  SwiftUIView.swift
//
//
//  Created by Алиса Вышегородцева on 19.04.2024.
//

import SwiftUI
import UIComponents
import Authorization

public struct ProfileSettingsView: View {
    @State private var input: String = ""
    @State private var inputState: TextFieldView.InputState = .correct
    
    @State private var inputPass: String = ""
    @State private var inputPassState: TextFieldView.InputState = .correct
    
    @State private var presentCode: Bool = false
    
    public init() { }
    
    public var body: some View {
        VStack(alignment: .leading) {
            back
            VStack(alignment: .leading, spacing: 16) {
                Text("Настройки")
                    .font(Font.custom("CoFoSans-Bold", size: 23))
                    .foregroundColor(.black)
                TextFieldView(model: .name, input: $input, inputState: $inputState)
                TextFieldView(model: .password, input: $inputPass, inputState: $inputPassState)
                HStack {
                    Spacer()
                    changePassword
                }
                Spacer()
                button
            }
            .padding(.top, 20)
        }
        .padding(.horizontal, 31)
        .padding(.bottom, 53)
    }
    
    var changePassword: some View {
        Button(action: {presentCode = true}) {
            Text("сменить пароль")
                .foregroundColor(Color(.accent))
                .font(Font.custom("CoFoSans-Regular", size: 13))
        }
        .navigationDestination(isPresented: $presentCode) {
            RegCodeView(from: .recreatePassword)
        }
    }
    
    var button: some View {
        MainButton(action: {
            //TODO: сохранить данные 
        }, label: "Сохранить")
    }
    
    var back: some View {
        BackButton()
    }
}

#Preview {
    ProfileSettingsView()
}
