//
//  SwiftUIView.swift
//
//
//  Created by Алиса Вышегородцева on 22.04.2024.
//

import SwiftUI
import UIComponents
import Types
import WrappingHStack

struct FilterView<Model: ChatViewModel>: View {
    @ObservedObject private var model: Model
    @Binding private var showTabBar: Bool
    
    public init(model: Model, showTabBar: Binding<Bool>) {
        self._model = ObservedObject(wrappedValue: model)
        self._showTabBar = showTabBar
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.defSpacing) {
            HStack {
                BackButton()
                Spacer()
                Button(action: {model.clearFilters()}) {
                    Text("Сбросить\nфильтры")
                        .font(Fonts.small)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("grey", bundle: .module))
                }
            }
            
            Text("Желаемые должности:")
                .font(Fonts.main)
                .foregroundColor(.black)
            WrappingHStack(model.desFilter, spacing: .constant(5), lineSpacing: 5) { filter in
                FilterBubble(filter: filter)
                    .onTapGesture {
                        model.onFilterTapped(id: filter.id, type: .profession)
                    }
            }
            Text("Желаемая позиция:")
                .font(Fonts.main)
                .foregroundColor(.black)
            WrappingHStack(model.expFilter, spacing: .constant(5), lineSpacing: 5) { filter in
                FilterBubble(filter: filter)
                    .onTapGesture {
                        model.onFilterTapped(id: filter.id, type: .level)
                    }
            }
            Text("Хочет работать в:")
                .font(Fonts.main)
                .foregroundColor(.black)
            WrappingHStack(model.comFilter, spacing: .constant(5), lineSpacing: 5) { filter in
                FilterBubble(filter: filter)
                    .onTapGesture {
                        model.onFilterTapped(id: filter.id, type: .company)
                    }
            }
            Spacer()
        }
        .onAppear {
            showTabBar = false
        }
        .onDisappear {
            showTabBar = true
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Constants.horizontal)
    }
}
