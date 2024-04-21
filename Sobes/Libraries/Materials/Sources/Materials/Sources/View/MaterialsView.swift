import SwiftUI
import UIComponents

public struct MaterialsView<Model: MaterialsViewModel>: View {

    public init(model: Model) {
        self._model = ObservedObject(wrappedValue: model)
    }

    public var body: some View {
        VStack(spacing: 30) {
            headline
            VStack(spacing: 24) {
                filters
                bubbles
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 31)
        .padding(.top, 66)
        .onAppear {
            model.onViewAppear()
        }
    }

    private var headline: some View {
        Text("Материалы для\nподготовки")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(Font.custom("CoFoSans-Bold", size: 23))
            .foregroundStyle(.black)
    }

    private var filters: some View {
        HStack {
            ForEach(model.filters) { filter in
                FilterBubble(filter: filter)
                    .onTapGesture {
                        model.onFilterTapped(id: filter.id)
                    }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var bubbles: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(model.materials, id: \.self) { material in
                    MaterialBubble(model: material)
                }
            }
        }
    }

    @ObservedObject private var model: Model

}
