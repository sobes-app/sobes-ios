import SwiftUI
import Types
import Toolbox

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

    private let model: Types.Material

    private func tip(model: Tip) -> some View {
        VStack(spacing: Constants.smallStack) {
            tipHeader(logo: model.logo, author: model.author, role: model.role)
            tipText(model.text)
        }
        .padding(Constants.elementPadding)
        .background {
            RoundedRectangle(cornerRadius: Constants.corner)
                .foregroundStyle(Color(.bubble))
        }
    }

    private func tipHeader(logo: Image, author: String, role: String) -> some View {
        HStack(spacing: Constants.elementPadding) {
            logo
                .resizable()
                .scaledToFit()
            VStack(spacing: Constants.zeroSpacing) {
                Text(author)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.black)
                    .font(Fonts.main)
                Text(role)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color(.grey))
                    .font(Fonts.main)
            }
        }
        .frame(height: 32)
    }

    private func tipText(_ text: String) -> some View {
        Text(text)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.black)
            .multilineTextAlignment(.leading)
            .font(Fonts.main)
    }

    private func article(model: Article) -> some View {
        HStack(alignment: .center, spacing: Constants.elementPadding) {
            if let logo = model.logo {
                AsyncImage(url: URL(string: FavIcon(logo)[.m]))
            }
            VStack(spacing: Constants.smallStack) {
                Text(model.author ?? "")
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color(.black))
                    .font(Fonts.mainBold)

                Text(model.text ?? "")
                    .multilineTextAlignment(.leading)
                    .lineLimit(5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color(.black))
                    .font(Fonts.small)
            }

            Image(systemName: "chevron.right")
                .resizable()
                .scaledToFit()
                .frame(height: 22)
                .foregroundStyle(Color(.grey))
        }
        .padding(Constants.elementPadding)
        .background {
            RoundedRectangle(cornerRadius: Constants.corner)
                .stroke(.black, lineWidth: Constants.strokeWidth)
        }
    }
}
