import SwiftUI
import UIComponents
import Toolbox
import Types

public struct MaterialsView<Model: MaterialsViewModel>: View {
    
    public init(model: Model) {
        self._model = StateObject(wrappedValue: model)
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: Constants.defSpacing) {
                headline
                filters
                materials
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, Constants.horizontal)
            .overlay {
                if model.isError {
                    ErrorView(retryAction: {
                        Task { @MainActor in
                            await model.onViewAppear()
                        }
                    })
                }
            }
        }
        .navigationBarBackButtonHidden()
        .task {
            await model.onViewAppear()
        }
    }
    
    private var headline: some View {
        Text("Материалы для подготовки")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(Fonts.heading)
            .foregroundStyle(.black)
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
                }
            }
            .scrollIndicators(.hidden)
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
