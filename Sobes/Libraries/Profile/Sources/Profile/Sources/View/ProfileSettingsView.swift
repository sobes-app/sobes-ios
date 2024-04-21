//
//  SwiftUIView.swift
//
//
//  Created by Алиса Вышегородцева on 19.04.2024.
//

import SwiftUI
import UIComponents
import Authorization

public struct ProfileSettingsView<Model: ProfileViewModel>: View {
    @ObservedObject private var model: Model
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var input: String = ""
    @State private var inputState: TextFieldView.InputState = .correct
    
    @State private var inputPass: String = ""
    @State private var inputPassState: TextFieldView.InputState = .correct
    
    @State private var presentCode: Bool = false
    @Binding private var showTabBar: Bool
    
    public init(model: Model, showTabBar: Binding<Bool>) {
        self._model = ObservedObject(wrappedValue: model)
        self._showTabBar = showTabBar
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            back
            VStack(alignment: .leading, spacing: Constants.defSpacing) {
                Text("Настройки")
                    .font(Fonts.heading)
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
            .padding(.top, Constants.topPadding)
        }
        .padding(.horizontal, Constants.horizontal)
        .padding(.bottom, Constants.bottom)
        .onAppear {
            showTabBar = false
        }
        .onDisappear {
            showTabBar = true
        }
    }
    
    var changePassword: some View {
        Button(action: {presentCode = true}) {
            Text("сменить пароль")
                .foregroundColor(Color(.accent))
                .font(Fonts.small)
        }
        .navigationDestination(isPresented: $presentCode) {
            //TODO: переделать нахуй
//            RegCodeView(from: .recreatePassword)
        }
    }
    
    var button: some View {
        MainButton(action: {
            model.saveNewName(newName: input)
            presentationMode.wrappedValue.dismiss()
        }, label: "Сохранить")
    }
    
    var back: some View {
        BackButton(onTap: {})
    }
}
