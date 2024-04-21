import SwiftUI
import Types

public struct MaterialBubble: View {

    public init(model: Types.Material) {
        self.model = model
    }

    public var body: some View {
        switch model {
        case .tip(let model):
            tip(model: model)
        case .article(let model):
            article(model: model)
        }
    }

    private func tip(model: Tip) -> some View {
        VStack(spacing: 10) {
            tipHeader(logo: model.logo, author: model.author, role: model.role)
            tipText(model.text)
        }
        .padding(15)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color(.bubble))
        }
    }

    private func tipHeader(logo: Image, author: String, role: String) -> some View {
        HStack(spacing: 15) {
            logo
                .resizable()
                .scaledToFit()
            VStack(spacing: 0) {
                Text(author)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.black)
                    .font(Font.custom("CoFoSans-Regular", size: 13))
                Text(role)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color(.secondary))
                    .font(Font.custom("CoFoSans-Regular", size: 13))
            }
        }
        .frame(height: 32)
    }

    private func tipText(_ text: String) -> some View {
        Text(text)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.black)
            .font(Font.custom("CoFoSans-Regular", size: 13))
            .multilineTextAlignment(.leading)
    }

    private func article(model: Article) -> some View {
        HStack(alignment: .center, spacing: 10) {
            model.logo
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 43)
            VStack(spacing: 10) {
                Text(model.author)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color(.black))
                    .font(Font.custom("CoFoSans-Bold", size: 13))

                Text(model.text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color(.black))
                    .font(Font.custom("CoFoSans-Regular", size: 13))
            }
        }
        .padding(15)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.black, lineWidth: 1)
        }
    }

    private let model: Types.Material
}
