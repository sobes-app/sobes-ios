import SwiftUI
import UIComponents

public enum Source {
    case recreatePassword
    case register
}

public struct RegCodeView: View {
    
    @State private var input: String = ""
    @State private var inputState: TextFieldView.InputState = .correct
    @State private var present: Bool = false
    private let from: Source

    public init(from: Source) {
        self.from = from
    }
    
    
    public var body: some View {
        VStack(alignment: .leading) {
            back
            VStack(alignment: .leading, spacing: 16) {
                Text("Код")
                    .font(Font.custom("CoFoSans-Bold", size: 23))
                    .foregroundColor(.black)
                Text("На вашу электронную почту было отправлено письмо с кодом подтверждения")
                    .font(Font.custom("CoFoSans-Regular", size: 17))
                    .foregroundColor(.black)
                TextFieldView(model: .code, input: $input, inputState: $inputState)
                HStack {
                    Spacer()
                    repeatCode
                }
            }
            .padding(.top, 20)
            Spacer()
            button
            
        }
        .padding(.horizontal, 31)
        .padding(.bottom, 53)
    }
    
    var button: some View {
        MainButton(action: {present = true}, label: "Дальше")
            .navigationDestination(isPresented: $present) {
                if from == .recreatePassword {
                    AuthNewPasswordView()
                        .navigationBarBackButtonHidden()
                } else if from == .register {
                    RegFinalView()
                        .navigationBarBackButtonHidden()
                }
            }
    }
    
    var back: some View {
        BackButton()
    }
    
    var repeatCode: some View {
        Button(action: {}) {
            Text("отправить повторно")
                .foregroundColor(Color(.accent))
                .font(Font.custom("CoFoSans-Regular", size: 13))
        }
    }
}

#Preview {
    RegCodeView(from: .recreatePassword)
}
