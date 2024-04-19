import SwiftUI
import UIComponents
import Authorization

@MainActor
struct EntryPointView: View {
    @State private var presentRegistration: Bool = false
    @State private var presentAuth: Bool = false
    @Binding var isAuthorized: Bool
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 30){
                Spacer()
                Text("Готовься продуктивно")
                    .font(Font.custom("CoFoSans-Bold", size: 35))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                button
                HStack {
                    Text("уже есть аккаунт?")
                        .font(Font.custom("CoFoSans-Regular", size: 13))
                        .foregroundColor(Color("grey",bundle: .main))
                    authButton
                }
            }
            .padding(.horizontal, 31)
            .padding(.bottom, 89)
        }
    }
    
    var authButton: some View {
        Button(action: {presentAuth = true}) {
            Text("Войти")
                .bold()
                .font(Font.custom("CoFoSans-Bold", size: 13))
                .foregroundColor(Color("accent", bundle: .main))
        }
        .navigationDestination(isPresented: $presentAuth) {
            AuthEntyPointView(model: LoginViewModelImpl(onLoginComplete: {
                isAuthorized = true
            }))
                .navigationBarBackButtonHidden()
        }
    }
    
    var button: some View {
        MainButton(action: {presentRegistration = true}, label: "Регистрация")
            .navigationDestination(isPresented: $presentRegistration) {
                RegEmailView(model: RegistrationViewModelImpl(onRegistrationComplete: {
                    isAuthorized = true
                }))
                    .navigationBarBackButtonHidden()
            }
    }
}

//#Preview {
////    EntryPointView()
//}
