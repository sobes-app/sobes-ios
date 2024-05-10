import SwiftUI
import UIComponents
import Combine

public struct RegCodeView<Model: AuthViewModel>: View {
    @EnvironmentObject var auth: Authentication
    
    public init(model: Model) {
        self._model = ObservedObject(wrappedValue: model)
    }
    
    public var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                BackButton()
                VStack(alignment: .leading, spacing: Constants.defSpacing) {
                    Text("Код")
                        .font(Fonts.heading)
                        .foregroundColor(.black)
                    Text("На вашу электронную почту ")
                        .font(Fonts.main)
                        .foregroundColor(.black)
                    + Text(model.email)
                        .font(Fonts.mainBold)
                        .foregroundColor(.black)
                    + Text(" было отправлено письмо с кодом подтверждения")
                        .font(Fonts.main)
                        .foregroundColor(.black)
                    TextFieldView(model: .code, input: $input)
                    HStack {
                        Spacer()
                        repeatCode
                    }
                }
                .padding(.top, Constants.topPadding)
                Spacer()
                VStack {
                    if incorrect {
                        IncorrectView(text: "неверный код подтверждения")
                    }
                    button
                }
                
            }
            .padding(.horizontal, Constants.horizontal)
            .padding(.bottom, Constants.bottom)
            .navigationDestination(isPresented: $present) {
                RegFinalView(model: model)
                    .navigationBarBackButtonHidden()
                    .environmentObject(auth)
            }

            if model.isLoading {
                SplashScreen()
            }
        }
    }
    
    private var button: some View {
        MainButton(
            action: {
                Task { @MainActor in
                    present = await model.validateCode(email: model.email, code: input)
                    if !present {
                        showIncorrect()
                    }
                }
            },
            label: "Дальше"
        )
    }
    
    private var repeatCode: some View {
        Button(action: {
            
        }) {
            Text("отправить повторно")
                .foregroundColor(Color(.accent))
                .font(Fonts.small)
        }
    }
    
    func showIncorrect() {
        withAnimation {
            incorrect = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            withAnimation {
                incorrect = false
            }
        })
    }
    
    @ObservedObject private var model: Model
    @State private var input: String = ""
    @State private var present: Bool = false
    @State private var incorrect: Bool = false
    
}
