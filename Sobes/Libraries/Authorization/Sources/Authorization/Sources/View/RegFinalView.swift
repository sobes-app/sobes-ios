import SwiftUI
import UIComponents

struct RegFinalView: View {
    @State private var inputName: String = ""
    @State private var inputNameState: TextFieldView.InputState = .correct
    
    @State private var inputPassword: String = ""
    @State private var inputPasswordState: TextFieldView.InputState = .correct
    
    @State private var inputRep: String = ""
    @State private var inputRepState: TextFieldView.InputState = .correct
    
    @State private var presentProfile: Bool = false
        
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
        MainButton(action: {presentProfile = true}, label: "Зарегистрироваться")
            .navigationDestination(isPresented: $presentProfile) {
                //TODO: зарегался надо на главную
            }
    }
    
    var back: some View {
        BackButton()
    }
}

#Preview {
    RegFinalView()
}
