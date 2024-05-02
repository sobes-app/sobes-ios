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
                    Text("На вашу электронную почту было отправлено письмо с кодом подтверждения")
                        .font(Fonts.main)
                        .foregroundColor(.black)
                    TextFieldView(model: .code, input: $input, inputState: $inputState)
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
            
            if model.isLoading {
                SplashScreen()
            }
        }
    }
    
    private var button: some View {
        MainButton(action: {
            Task { @MainActor in
                present = await model.validateCode(code: input)
                if !present {
                    withAnimation {
                        incorrect = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        withAnimation {
                            incorrect = false
                        }
                    })
                }
            }
        }, label: "Дальше")
        .navigationDestination(isPresented: $present) {
            RegFinalView(model: model)
                .navigationBarBackButtonHidden()
                .environmentObject(auth)
        }
    }
    
    private var repeatCode: some View {
        Button(action: {
            
        }) {
            Text("отправить повторно")
                .foregroundColor(Color(.accent))
                .font(Fonts.small)
        }
    }
    
    @ObservedObject private var model: Model
    @State private var input: String = ""
    @State private var inputState: TextFieldView.InputState = .correct
    @State private var present: Bool = false
    @State private var incorrect: Bool = false
    
}
