import SwiftUI
import Types

public struct ChevronButton: View {

    public enum ComponentType {
        case button(text: String)
        case question(InterviewQuestion)
    }

    public init(model: ComponentType) {
        self.model = model
    }

    public var body: some View {
        Group {
            switch model {
            case .button(let text):
                button(text: text)
            case .question(let model):
                question(model)
            }
        }
        .padding(Constants.elementPadding)
        .background {
            RoundedRectangle(cornerRadius: Constants.corner)
                .foregroundStyle(Color(.bubble))
        }
    }

    private func button(text: String) -> some View {
        HStack {
            Text(text)
                .font(Fonts.main)
                .foregroundStyle(.black)
            Spacer()
            chevron
        }
    }

    private func question(_ question: InterviewQuestion) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: Constants.smallStack) {
                Text(question.text)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
                    .font(Fonts.main)
                if let result = question.result {
                    Group {
                        Text("результат ")
                            .font(Fonts.main)
                        +
                        Text("\(result)%")
                            .font(Fonts.mainBold)
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
