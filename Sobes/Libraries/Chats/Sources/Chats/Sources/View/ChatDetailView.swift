import SwiftUI
import UIComponents

struct ChatDetailView: View {
    @State private var input: String = ""
    @State private var inputState: TextFieldView.InputState = .correct
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding private var showTabBar: Bool
    
    public init(showTabBar: Binding<Bool>) {
        self._showTabBar = showTabBar
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: Constants.defSpacing) {
            HStack(spacing: Constants.defSpacing) {
                back
                Text("Яна Барбашина")
                    .font(Fonts.mainBold)
                    .foregroundColor(.black)
            }
            description
                .frame(maxWidth: .infinity, alignment: .leading)
            Rectangle()
                .foregroundColor(Color(.light))
                .frame(height: 1)  
            Spacer()
            TextFieldView(model: .chat, input: $input, inputState: $inputState)
            
        }
        .padding(.horizontal, Constants.horizontal)
        .padding(.bottom, Constants.bottom)
        .onAppear {
            showTabBar = false
        }
        .onDisappear {
            showTabBar = true
        }
    }
    
    var description: some View {
        VStack(alignment: .leading) {
            Text("Желаемый уровень: Jun/Jun+")
                .font(Fonts.small)
                .foregroundColor(.black)
            Text("Опыт: менее года")
                .font(Fonts.small)
                .foregroundColor(.black)
            Text("Хочет работать в: Яндекс, Тинькофф")
                .font(Fonts.small)
                .foregroundColor(.black)
        }
    }
    
    var back: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.backward")
                .foregroundColor(.black)
                .frame(width: 10, height: 10, alignment: .leading)
        }
    }
}
