import SwiftUI
import UIComponents

public struct MaterialsView<Model: MaterialsViewModel>: View {

    public init(model: Model) {
        self._model = ObservedObject(wrappedValue: model)
        self._filterBubbleTapped = State(initialValue: false)
        self._filterBubbleTapped1 = State(initialValue: false)
        self._filterBubbleTapped2 = State(initialValue: false)
    }

    public var body: some View {
        VStack(spacing: 30) {
            headline
            filters
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .ignoresSafeArea()
        .padding(.leading, 31)
        .padding(.top, 26)
    }

    private var headline: some View {
        HStack {
            Text("Материалы для подготовки")
                .lineLimit(2, reservesSpace: true)
                .font(Font.custom("CoFoSans-Bold", size: 23))
                .foregroundStyle(.black)
        }
    }

    private var filters: some View {
        HStack(spacing: 10) {
            FilterBubble(tapped: $filterBubbleTapped, text: "Тинькофф")
                .onTapGesture {
                    filterBubbleTapped.toggle()
                }
            FilterBubble(tapped: $filterBubbleTapped1, text: "Яндекс")
                .onTapGesture {
                    filterBubbleTapped1.toggle()
                }
            FilterBubble(tapped: $filterBubbleTapped2, text: "OZON")
                .onTapGesture {
                    filterBubbleTapped2.toggle()
                }
        }

    }

    @ObservedObject private var model: Model
    @State private var filterBubbleTapped: Bool
    @State private var filterBubbleTapped1: Bool
    @State private var filterBubbleTapped2: Bool

}
