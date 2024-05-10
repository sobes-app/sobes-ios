import SwiftUI
import UIComponents

public struct RegEmailView<Model: AuthViewModel>: View {
    
    @EnvironmentObject var auth: Authentication
    
    public init(model: Model) {
        self._model = ObservedObject(wrappedValue: model)
    }
    
    public var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                BackButton()
                VStack(alignment: .leading, spacing: Constants.defSpacing) {
                    Text("Поехали!")
                        .font(Fonts.heading)
                        .foregroundColor(.black)
                    TextFieldView(model: .email, input: $input)
                    Spacer()
                    VStack {
                        if incorrect {
                            IncorrectView(text: message)
                        }
                        button
                    }
                }
                .padding(.top, Constants.topPadding)
            }
            .padding(.horizontal, Constants.horizontal)
            .padding(.bottom, Constants.bottom)
            .navigationDestination(isPresented: $presentCode) {
                RegCodeView(model: model)
                    .environmentObject(auth)
                    .navigationBarBackButtonHidden()
            }

            if model.isLoading {
                SplashScreen()
            }
        }
    }
    
    private var button: some View {
        MainButton(
            action: {
                if TextFieldValidator.isInputValid(.email(input)) {
                    Task { @MainActor in
                        presentCode = await model.sendCodetoEmail(email: input)
                        if !presentCode {
                            message = "ошибка отправки кода"
                            showIncorrect()
                        }
                    }
                } else {
                    showIncorrect()
                }
            },
            label: "Дальше"
        )
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
    @State private var presentCode: Bool = false
    @State private var incorrect: Bool = false
    @State private var message: String = "неверный формат почты"
}
