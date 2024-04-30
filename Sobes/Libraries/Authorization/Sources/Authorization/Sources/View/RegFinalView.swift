import SwiftUI
import UIComponents

struct RegFinalView<Model: AuthViewModel>: View {
    @EnvironmentObject var auth: Authentication

    public init(model: Model) {
        self._model = ObservedObject(wrappedValue: model)
    }
        
    public var body: some View {
        VStack(alignment: .leading) {
            BackButton()
            VStack(alignment: .leading, spacing: Constants.defSpacing){
                Text("Почти закончили!")
                    .font(Fonts.heading)
                    .foregroundColor(.black)
                TextFieldView(model: .name, input: $inputName, inputState: $inputNameState)
                TextFieldView(model: .password, input: $inputPassword, inputState: $inputPasswordState)
                TextFieldView(model: .repPassword, input: $inputRep, inputState: $inputRepState)
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
    }
    
    var button: some View {
        MainButton(
            action: {
                if inputPassword != inputRep {
                    message = "Пароли не совпадают"
                    withAnimation {
                        incorrect = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        withAnimation {
                            incorrect = false
                        }
                    })
                }
                Task { @MainActor in
                    if !(await model.registerUser(username: inputName, password: inputPassword)) {
                        auth.updateStatus(success: false)
                        message = "Возникла ошибка при регистрации"
                        withAnimation {
                            incorrect = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            withAnimation {
                                incorrect = false
                            }
                        })
                    } else {
                        auth.updateStatus(success: true)
                    }
                }
            },
            label: "Зарегистрироваться"
        )
    }

    @ObservedObject private var model: Model

    @State private var inputName: String = ""
    @State private var inputNameState: TextFieldView.InputState = .correct

    @State private var inputPassword: String = ""
    @State private var inputPasswordState: TextFieldView.InputState = .correct

    @State private var inputRep: String = ""
    @State private var inputRepState: TextFieldView.InputState = .correct

    @State private var message: String = ""
    @State private var incorrect: Bool = false

}

