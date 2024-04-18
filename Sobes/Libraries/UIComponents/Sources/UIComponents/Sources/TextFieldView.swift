//
//  SwiftUIView.swift
//
//
//  Created by Алиса Вышегородцева on 18.04.2024.
//

import SwiftUI

public struct TextFieldView: View {
    public enum Model {
        case name
        case password
        case repPassword
        case email
        case code
        case chat
    }
    
    public enum InputState {
        case correct
        case incorrect
        case passwords
    }
    
    @Binding var input: String
    @Binding var inputState: InputState
    var isSendButtonAvailable: Bool
    
    public init(
        model: Model,
        input: Binding<String>,
        inputState: Binding<InputState>,
        isSendButtonAvailable: Bool = true
    ) {
        self.model = model
        self._input = input
        self._inputState = inputState
        self.isSendButtonAvailable = isSendButtonAvailable
    }
    
    public var body: some View {
        switch model {
        case .name:
            name
        case .password:
            password
        case .repPassword:
            repPassword
        case .email:
            email
        case .code:
            code
        case .chat:
            chat
        }
    }
    
    var roundedRec: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(
                isFocused ? Color(.accent) : .clear,
                lineWidth: 1
            )
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.light))
            )
    }
    
    var name: some View {
        HStack(spacing: 10) {
            Image(systemName: "person.fill")
                .foregroundColor(Color("grey", bundle: .module))
            TextField("введите фио...", text: $input)
                .foregroundColor(Color("grey", bundle: .module))
                .focused($isFocused)
                .disableAutocorrection(true)
        }
        .padding(15)
        .background {
            roundedRec
        }
    }
    var password: some View {
        HStack(spacing: 10) {
            Image(systemName: "lock")
                .foregroundColor(Color("grey", bundle: .module))
            SecureField("введите пароль...", text: $input)
                .foregroundColor(Color("grey", bundle: .module))
                .focused($isFocused)
                .disableAutocorrection(true)
        }
        .padding(15)
        .background {
            roundedRec
        }
    }
    var repPassword: some View {
        HStack(spacing: 10) {
            Image(systemName: "lock")
                .foregroundColor(Color("grey", bundle: .module))
            SecureField("повторите пароль...", text: $input)
                .foregroundColor(Color("grey", bundle: .module))
                .focused($isFocused)
                .disableAutocorrection(true)
        }
        .padding(15)
        .background {
            roundedRec
        }
    }
    var email: some View {
        HStack(spacing: 10) {
            Image(systemName: "envelope")
                .foregroundColor(Color("grey", bundle: .module))
            TextField("введите почту...", text: $input)
                .foregroundColor(Color("grey", bundle: .module))
                .focused($isFocused)
                .disableAutocorrection(true)
        }
        .padding(15)
        .background {
            roundedRec
        }
    }
    var code: some View {
        HStack(spacing: 10) {
            TextField("введите код...", text: $input)
                .foregroundColor(Color("grey", bundle: .module))
                .focused($isFocused)
                .disableAutocorrection(true)
        }
        .padding(15)
        .background {
            roundedRec
        }
    }
    var chat: some View {
        HStack(spacing: 10) {
            TextField("сообщение...", text: $input)
                .foregroundColor(Color("grey", bundle: .module))
                .focused($isFocused)
                .disableAutocorrection(true)
            Spacer()
            Image(systemName: "chevron.forward")
                .foregroundColor(Color("grey", bundle: .module))
        }
        .padding(15)
        .background {
            roundedRec
        }
    }
    
    @FocusState private var isFocused: Bool
    private let model: Model
}
