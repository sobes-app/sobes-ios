import Foundation


public enum InputType {
    case email(String)
    case password(String)
    case restoreCode(String)
    case name(String)
}

public class TextFieldValidator {
    
    public init() {}
    
    public static func isInputValid(_ input: InputType) -> Bool {
        switch input {
        case .email(let text):
            return isUsernameOrEmailValid(text)
        case .password(let text):
            return isPasswordValid(text)
        case .restoreCode(let text):
            return isRestoreCodeValid(text)
        case .name(let text):
            return isNameCorrect(text)
        }
    }
    
    private static func isUsernameOrEmailValid(_ text: String) -> Bool {
        let simplyfiesText = (text.lowercased()).trimmingCharacters(in: .whitespaces)
        guard simplyfiesText.count > 0 else { return false }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: simplyfiesText)
    }
    
    private static func isPasswordValid(_ password: String) -> Bool {
        return password.count > 0
    }
    
    private static func isRestoreCodeValid(_ code: String) -> Bool {
        if code == "123456" {
            return true
        }
        return false
    }
    
    private static func isNameCorrect(_ name: String) -> Bool {
        return !name.isEmpty
    }
    
}
