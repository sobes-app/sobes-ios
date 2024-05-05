import SwiftUI
import UIComponents
import Authorization
import SwiftUIGIF
import Providers

@MainActor
struct EntryPointView: View {
    @EnvironmentObject var auth: Authentication

    @Binding var selectedTab: TabItem
    let provider: ProfileProvider

    var body: some View {
        NavigationStack {
            VStack (spacing: 30) {
                Spacer()
                GIFImage(name: "entryPointGif")
                    .frame(width: 600)
                Text("Готовься продуктивно")
                    .font(Font.system(size: 35, weight: .bold))
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
            .navigationDestination(isPresented: $presentRegistration) {
                RegEmailView(model: AuthViewModelImpl(onRegistrationComplete: {
                    selectedTab = .materials
                }, provider: provider))
                .environmentObject(auth)
                .navigationBarBackButtonHidden()
            }
        }
        .onAppear {
            auth.updateStatus(success: false)
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
            AuthEntryPointView(model: AuthViewModelImpl(onLoginComplete: {
                selectedTab = .materials
            }, provider: provider))
            .environmentObject(auth)
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
    }
}
