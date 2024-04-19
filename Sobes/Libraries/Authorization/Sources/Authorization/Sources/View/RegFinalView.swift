import SwiftUI
import UIComponents

struct RegFinalView<Model: RegistrationViewModel>: View {
    @ObservedObject private var model: Model
    
    @State private var inputName: String = ""
    @State private var inputNameState: TextFieldView.InputState = .correct
    
    @State private var inputPassword: String = ""
    @State private var inputPasswordState: TextFieldView.InputState = .correct
    
    @State private var inputRep: String = ""
    @State private var inputRepState: TextFieldView.InputState = .correct
    
    @State private var presentProfile: Bool = false
    
    public init(model: Model) {
        self._model = ObservedObject(wrappedValue: model)
    }
        
    public var body: some View {
        VStack(alignment: .leading) {
            back
            VStack(alignment: .leading, spacing: 16){
                Text("Почти закончили!")
                    .font(Font.custom("CoFoSans-Bold", size: 23))
                    .foregroundColor(.black)
                TextFieldView(model: .name, input: $inputName, inputState: $inputNameState)
                TextFieldView(model: .password, input: $inputPassword, inputState: $inputPasswordState)
                TextFieldView(model: .repPassword, input: $inputRep, inputState: $inputRepState)
                Spacer()
                button
            }
            .padding(.top, 20)
        }
        .padding(.horizontal, 31)
        .padding(.bottom, 53)
    }
    
    var button: some View {
        MainButton(action: {
            model.onRegisterTap()
        }, label: "Зарегистрироваться")
    }
    
    var back: some View {
        BackButton(onTap: {})
    }
}

