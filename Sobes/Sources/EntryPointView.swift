import SwiftUI
import UIComponents
import Authorization
import SwiftUIGIF

@MainActor
struct EntryPointView: View {

    @Binding var isAuthorized: Bool
    @Binding var selectedTab: TabItem

    var body: some View {
        NavigationStack {
            VStack (spacing: 30) {
                Spacer()
                GIFImage(name: "entryPointGif")
                    .frame(width: 600)
                Text("Готовься продуктивно")
                    .font(Font.custom("CoFoSans-Bold", size: 35))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                button
                HStack {
                    Text("уже есть аккаунт?")
                        .font(Fonts.main)
                        .foregroundColor(.black)
                    authButton
                }
            }
            .padding(.horizontal, Constants.horizontal)
            .padding(.bottom, 89)
        }
    }

    @State private var presentRegistration: Bool = false
    @State private var presentAuth: Bool = false

    private var authButton: some View {
        Button(
            action: {
                presentAuth = true
            }
        ) {
            Text("Войти")
                .bold()
                .font(Fonts.mainBold)
                .foregroundColor(Color(.accent))
        }
        .navigationDestination(isPresented: $presentAuth) {
            AuthEntryPointView(model: LoginViewModelImpl(onLoginComplete: {
                isAuthorized = true
                selectedTab = .materials
            }))
            .navigationBarBackButtonHidden()
        }
    }
    
    private var button: some View {
        MainButton(
            action: {
                presentRegistration = true
            },
            label: "Регистрация"
        )
        .navigationDestination(isPresented: $presentRegistration) {
            RegEmailView(model: RegistrationViewModelImpl(onRegistrationComplete: {
                isAuthorized = true
                selectedTab = .profile
            }))
            .navigationBarBackButtonHidden()
        }
    }
}
