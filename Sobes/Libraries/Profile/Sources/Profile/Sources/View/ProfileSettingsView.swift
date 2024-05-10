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
            BackButton()
            VStack(alignment: .leading, spacing: Constants.defSpacing) {
                Text("Настройки")
                    .font(Fonts.heading)
                    .foregroundColor(.black)
                resetPasswordButton
                Spacer()
            }
            .padding(.top, Constants.topPadding)
        }
        .padding(.horizontal, Constants.horizontal)
        .padding(.bottom, Constants.bottom)
        .onAppear {
            withAnimation {
                showTabBar = false
            }
        }
        .onDisappear {
            if !presentChangePassword {
                withAnimation {
                    showTabBar = true
                }
            }
        }
    }
    
    private var resetPasswordButton: some View {
        ChevronButton(model: .button(text: "Сменить пароль"))
            .onTapGesture {
                presentChangePassword = true
            }
            .navigationDestination(isPresented: $presentChangePassword) {
                ChangePasswordView(model: model)
                    .navigationBarBackButtonHidden()
            }
    }
    
    @ObservedObject private var model: Model
    
    @State private var presentChangePassword: Bool = false
    @Binding private var showTabBar: Bool
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
}
