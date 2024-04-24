import SwiftUI
import UIComponents
import Types

public struct MaterialsView<Model: MaterialsViewModel>: View {
    
    public init(model: Model) {
        self._model = StateObject(wrappedValue: model)
    }
    
    public var body: some View {
        VStack(spacing: Constants.defSpacing) {
            headline
            filters
            bubbles
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, Constants.horizontal)
        .onAppear {
            model.onViewAppear()
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
                        model.onMaterialsFilterTapped(id: filter.id)
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
                        model.onFilterTapped(id: filter.id)
                    }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var bubbles: some View {
        ScrollView {
            VStack(spacing: Constants.defSpacing) {
                ForEach(model.materials, id: \.self) { material in
                    MaterialBubble(model: material)
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    @StateObject private var model: Model

}

extension Array where Array == [Types.Filter] {

    public var isTipsFilterActive: Bool {
        return self.firstIndex(where: { $0.isActive }) == 0
    }

}
