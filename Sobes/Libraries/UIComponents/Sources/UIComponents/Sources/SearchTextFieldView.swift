import SwiftUI

public struct SearchTextFieldView: View {
    private var onAppear: (() -> Void)
    private var buttonClicked: (() -> Void)
    @Binding private var input: String
    @Binding private var filterIsOn: Bool
    @FocusState private var isFocused: Bool
    var isChats: Bool = false
    
    public init(onAppear: @escaping () -> Void, input: Binding<String>, buttonAction: @escaping () -> Void, filterIsOn: Binding<Bool>, isChats: Bool = false) {
        self.onAppear = onAppear
        self._input = input
        self.buttonClicked = buttonAction
        self._filterIsOn = filterIsOn
        self.isChats = isChats
    }
    
    public var body: some View {
        HStack(spacing: 5) {
            TextField("поиск...", text: $input, axis: .vertical)
                .foregroundColor(Color("grey", bundle: .module))
                .focused($isFocused)
                .lineLimit(1)
                .disableAutocorrection(true)
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: Constants.corner)
                        .foregroundColor(Color(.light))
                }
            if !isChats {
                Spacer()
                Button(action: {buttonClicked()}) {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(filterIsOn ? .black : .white)
                        .background {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(filterIsOn ? Color(.light) : Color(.accent))
                        }
                }
                .onAppear {
                    onAppear()
                }
            }
        }
    }
}

