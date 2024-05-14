import SwiftUI
import Types
import UIComponents

public struct ArticleView<Model: MaterialsViewModel>: View {

    public init(model: Model, article: Types.Article, showTabBar: Binding<Bool>) {
        self._model = ObservedObject(wrappedValue: model)
        self.notParsedArticle = article
        self._showTabBar = showTabBar
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Constants.defSpacing) {
                header
                source
                keywords
                authorBubble
                bodyText
            }
        }
        .onAppear {
            withAnimation {
                showTabBar.toggle()
            }
        }
        .onDisappear {
            withAnimation {
                showTabBar.toggle()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .navigationBarBackButtonHidden()
        .padding(Constants.horizontal)
        .task {
            article = await model.getParsedArticle(article: notParsedArticle)
        }
    }

    private var header: some View {
        VStack(alignment: .leading) {
            BackButton()
            heading
        }
    }

    private var heading: some View {
        Text(article?.heading ?? "")
            .font(Fonts.heading)
            .foregroundStyle(.black)
            .multilineTextAlignment(.leading)
    }

    private var source: some View {
        HStack {
            Text("Источник: \(article?.source ?? "")")
                .font(Fonts.small)
                .foregroundStyle(Color(.grey))
            Spacer()
            if let article {
                Link(destination: URL(string: article.url)!) {
                    HStack {
                        Text("К полной версии")
                            .font(Fonts.small)
                        Image(systemName: "arrow.right")
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var keywords: some View {
        if showAllTags {
            VStack(alignment: .leading) {
                ForEach(article?.tags ?? [], id: \.self) { tag in
                    Text("#\(tag)")
                        .foregroundStyle(.blue)
                        .font(Fonts.small)
                }
                Button {
                    showAllTags = false
                } label: {
                    HStack {
                        Text("Свернуть")
                            .font(Fonts.small)
                        Image(systemName: "chevron.up")
                    }
                    .foregroundStyle(.black)
                }
            }
        } else {
            VStack(alignment: .leading) {
                ForEach(article?.tags.prefix(3) ?? [], id: \.self) { tag in
                    Text("#\(tag)")
                        .foregroundStyle(.blue)
                        .font(Fonts.small)
                }
                if article?.tags.count ?? 0 > 3 {
                    Button {
                        showAllTags = true
                    } label: {
                        HStack {
                            Text("Показать все")
                                .font(Fonts.small)
                            Image(systemName: "chevron.down")
                        }
                        .foregroundStyle(.black)
                    }
                }
            }
        }
    }

    private var authorBubble: some View {
        VStack(alignment: .leading) {
            Text(article?.author ?? "")
                .font(Fonts.main)
                .foregroundStyle(.black)
                .multilineTextAlignment(.leading)
            Text(article?.datePublished ?? "")
                .font(Fonts.small)
                .foregroundStyle(Color(.grey))
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Constants.elementPadding)
        .background {
            RoundedRectangle(cornerRadius: Constants.corner)
                .foregroundStyle(Color(.bubble))
        }
    }

    private var bodyText: some View {
        Text(article?.bodyText ?? "")
            .textSelection(.enabled)
            .font(Fonts.main)
            .foregroundStyle(.black)
            .multilineTextAlignment(.leading)
    }

    @State private var showAllTags: Bool = false
    @State private var article: ParsedArticle?
    @ObservedObject private var model: Model
    @Binding private var showTabBar: Bool
    private let notParsedArticle: Article

}
