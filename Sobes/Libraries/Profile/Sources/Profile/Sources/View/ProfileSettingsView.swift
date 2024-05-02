import SwiftUI
import UIComponents
import Authorization

public struct ProfileSettingsView<Model: ProfileViewModel>: View {
    
    public init(model: Model, showTabBar: Binding<Bool>) {
        self._model = ObservedObject(wrappedValue: model)
        self._showTabBar = showTabBar
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            BackButton(onTap: {
                showTabBar = true
            })
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
            withoutAnimation {
                showTabBar = false
            }
        }
    }
    
    private var changePassword: some View {
        Button(action: {presentChangePassword = true}) {
            Text("сменить пароль")
                .foregroundColor(Color(.accent))
                .font(Fonts.small)
        }
        .navigationDestination(isPresented: $presentChangePassword) {
            ChangePasswordView(model: model)
                .navigationBarBackButtonHidden()
        }
    }
    
    private var button: some View {
        MainButton(
            action: {
                model.saveNewName(newName: input)
                withoutAnimation {
                    presentationMode.wrappedValue.dismiss()

                }
                showTabBar = true
            },
            label: "Сохранить"
        )
    }
    
    @ObservedObject private var model: Model
    
    @State private var input: String = ""
    @State private var inputState: TextFieldView.InputState = .correct
    
    @State private var inputPass: String = ""
    @State private var inputPassState: TextFieldView.InputState = .correct
    
    @State private var presentChangePassword: Bool = false
    @Binding private var showTabBar: Bool
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
}
