import SwiftUI

public struct ChevronButton: View {

    public enum ComponentType {
        case button(text: String)
        case question(text: String, result: Double? = nil)
    }

    public init(model: ComponentType) {
        self.model = model
    }

    public var body: some View {
        Group {
            switch model {
            case .button(let text):
                button(text: text)
            case .question(let text, let result):
                question(text: text, result: result)
            }
        }
        .padding(15)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color(.bubble))
        }
    }

    private func button(text: String) -> some View {
        HStack {
            Text(text)
                .font(Font.custom("CoFoSans-Regular", size: 17))
                .foregroundStyle(.black)
            Spacer()
            chevron
        }
    }

    private func question(text: String, result: Double? = nil) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(text)
                    .font(Font.custom("CoFoSans-Regular", size: 13))
                if let result {
                    Group {
                        Text("результат ")
                            .font(Font.custom("CoFoSans-Regular", size: 13))
                        +
                        Text(String(format: "%.1f", result))
                            .font(Font.custom("CoFoSans-Bold", size: 13))
                        +
                        Text("%")
                            .font(Font.custom("CoFoSans-Bold", size: 13))
                    }
                    .foregroundStyle(Color(.accent))
                }
            }
            Spacer()
            chevron
        }
    }

    private var chevron: some View {
        Image(systemName: "chevron.right")
            .resizable()
            .scaledToFit()
            .frame(height: 16)
            .foregroundStyle(Color(.blacky))
    }

    private let model: ComponentType

}
