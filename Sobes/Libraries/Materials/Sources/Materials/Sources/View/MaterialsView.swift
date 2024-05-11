import SwiftUI
import Toolbox
import Types
import UIComponents

public struct MaterialsView<Model: MaterialsViewModel>: View {
    
    public init(model: Model) {
        self._model = StateObject(wrappedValue: model)
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: Constants.defSpacing) {
                headline
                loadedView
                    .overlay {
                        if model.isError {
                            ErrorView(
                                retryAction: {
                                    Task { @MainActor in
                                        await model.onViewAppear()
                                    }
                                }
                            )
                        }
                    }
            }
            .overlay(alignment: .bottom) {
                adminButtons
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, Constants.horizontal)
        }
        .navigationBarBackButtonHidden()
        .task {
            await model.onViewAppear()
        }
    }
    
    private var headline: some View {
        Text("Материалы для\nподготовки")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(Fonts.heading)
            .foregroundStyle(.black)
    }

    private var loadedView: some View {
        VStack(spacing: Constants.defSpacing) {
            filters
            materials
        }
    }

    @ViewBuilder
    private var filters: some View {
        HStack {
            ForEach(model.materialsFilters) { filter in
                FilterBubble(filter: filter)
                    .onTapGesture {
                        Task { @MainActor in
                            await model.onMaterialsFilterTapped(id: filter.id)
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        if model.materialsFilters.isTipsFilterActive {
            companyFilters
        }
    }

    private var companyFilters: some View {
        HStack {
            ForEach(model.filters) { filter in
                FilterBubble(filter: filter, type: .secondary)
                    .onTapGesture {
                        Task { @MainActor in
                            await model.onFilterTapped(id: filter.id)
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var materials: some View {
        if model.isLoading {
            LoadingScreen(placeholder: "Загружаем материалы...")
        } else {
            ScrollView {
                VStack(spacing: Constants.defSpacing) {
                    ForEach(model.materials, id: \.self) { material in
                        if case .article(let article) = material {
                            NavigationLink(destination: ArticleView(model: model, id: article.id)) {
                                MaterialBubble(model: material)
                            }
                        } else {
                            MaterialBubble(model: material)
                        }
                    }
                    Spacer()
                        .frame(height: 50)
                }
            }
            .scrollIndicators(.hidden)
        }
    }

    @ViewBuilder
    private var adminButtons: some View {
        if model.appMode == .admin {
            if model.materialsFilters.isTipsFilterActive {
                addTipButton
                    .padding(.horizontal, 20)
            } else {
                addArticleButton
                    .padding(.horizontal, 20)
            }
        }
    }

    private var addArticleButton: some View {
        NavigationLink(destination: AddMaterialView(model: model, type: .article)) {
            Text("Добавить статью")
                .font(Fonts.mainBold)
                .foregroundStyle(.white)
                .padding(.vertical, Constants.elementPadding)
                .frame(maxWidth: .infinity, alignment: .center)
                .background {
                    RoundedRectangle(cornerRadius: Constants.corner)
                        .foregroundStyle(Color(.accent))
                }
        }
    }

    private var addTipButton: some View {
        NavigationLink(destination: AddMaterialView(model: model, type: .tip)) {
            Text("Добавить совет")
                .font(Fonts.mainBold)
                .foregroundStyle(.white)
                .padding(.vertical, Constants.elementPadding)
                .frame(maxWidth: .infinity, alignment: .center)
                .background {
                    RoundedRectangle(cornerRadius: Constants.corner)
                        .foregroundStyle(Color(.accent))
                }
        }
    }

    @State private var isPresentWebView = false
    @StateObject private var model: Model

}

extension Array where Array == [Types.Filter] {

    public var isTipsFilterActive: Bool {
        return self.firstIndex(where: { $0.isActive }) == 0
    }

}
