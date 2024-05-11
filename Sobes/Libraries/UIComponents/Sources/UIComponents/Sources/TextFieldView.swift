import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

public struct TextFieldView: View {

    public enum Model {
        case name
        case password
        case email
        case code
        case chat
        case search
    }
    
    public init(
        model: Model,
        input: Binding<String>,
        onSend: (() -> Void)? = nil,
        onFilter: (() -> Void)? = nil,
        passwordText: String? = nil
    ) {
        self.model = model
        self._input = input
        self.onSend = onSend
        self.onFilter = onFilter
        self.passwordText = passwordText
    }
    
    public var body: some View {
        switch model {
        case .name:
            name
        case .password:
            password
        case .email:
            email
        case .code:
            code
        case .chat:
            chat
        case .search:
            search
        }
    }
    
    var roundedRec: some View {
        RoundedRectangle(cornerRadius: Constants.corner)
            .stroke(
                isFocused ? Color(.accent) : .clear,
                lineWidth: Constants.strokeWidth
            )
            .background(
                RoundedRectangle(cornerRadius: Constants.corner)
                    .fill(Color(.light))
            )
    }
    
    var name: some View {
        HStack(spacing: Constants.smallStack) {
            Image(systemName: "person.fill")
                .foregroundColor(Static.Colors.grey)
            TextField("введите фио...", text: $input)
                .foregroundColor(.black)
                .focused($isFocused)
                .disableAutocorrection(true)
        }
        .padding(Constants.elementPadding)
        .background {
            roundedRec
        }
    }
    
    var password: some View {
        HStack(spacing: Constants.smallStack) {
            Image(systemName: "lock")
                .foregroundColor(Static.Colors.grey)
            SecureField(passwordText ?? "", text: $input)
                .foregroundColor(.black)
                .focused($isFocused)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
        }
        .padding(Constants.elementPadding)
        .background {
            roundedRec
        }
    }

    var email: some View {
        HStack(spacing: Constants.smallStack) {
            Image(systemName: "envelope")
                .foregroundColor(Static.Colors.grey)
            TextField("введите почту...", text: $input)
                .foregroundColor(.black)
                .focused($isFocused)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
        }
        .padding(Constants.elementPadding)
        .background {
            roundedRec
        }
    }

    var code: some View {
        HStack(spacing: Constants.smallStack) {
            TextField("введите код...", text: $input)
                .foregroundColor(.black)
                .focused($isFocused)
                .disableAutocorrection(true)
        }
        .padding(Constants.elementPadding)
        .background {
            roundedRec
        }
    }
    
    var search: some View {
        HStack(spacing: 5) {
            TextField("поиск...", text: $input, axis: .vertical)
                .foregroundColor(.black)
                .focused($isFocused)
                .disableAutocorrection(true)
                .onSubmit {
                    onSend?()
                }
                .padding(5)
                .background {
                    roundedRec
                }
            Spacer()
            Button(
                action: {
                    onSend?()
                }
            ) {
                Image(systemName: "arrow.up")
                    .foregroundColor(input.isEmpty ? Static.Colors.grey : .white)
                    .onTapGesture {
                        onFilter?()
                    }
                    .background {
                        Circle()
                            .frame(width: 30, height: 30)
                            .foregroundColor(input.isEmpty ? Color(.light) : Color(.accent))
                    }
            }
        }
    }
    
    var chat: some View {
        HStack(spacing: 5) {
            TextField("сообщение...", text: $input, axis: .vertical)
                .foregroundColor(.black)
                .focused($isFocused)
                .onSubmit {
                    onSend?()
                    input = ""
                }
                .padding(Constants.elementPadding)
                .background {
                    roundedRec
                }
            Spacer()
            Button(
                action: {
                    onSend?()
                    input = ""
                }
            ) {
                Image(systemName: "arrow.up")
                    .foregroundColor(input.isEmpty ? Static.Colors.grey : .white)
                    .background {
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundColor(input.isEmpty ? Color(.light) : Color(.accent))
                    }
            }
            .disabled(input.isEmpty)
        }
    }
    
    @FocusState private var isFocused: Bool
    @Binding private var input: String
    private let model: Model
    private let onSend: (()-> Void)?
    private let onFilter: (()-> Void)?
    private let passwordText: String?
}

private enum Static {
    enum Colors {
        static let grey: Color = Color("grey", bundle: .main)
    }
}

