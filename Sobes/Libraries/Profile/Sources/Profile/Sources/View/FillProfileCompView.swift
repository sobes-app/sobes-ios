//
//  SwiftUIView.swift
//
//
//  Created by Алиса Вышегородцева on 19.04.2024.
//

import SwiftUI
import UIComponents
import Types

struct FillProfileCompView<Model: ProfileViewModel>: View {
    @ObservedObject private var model: Model
    
    @State private var yandex: Bool = false
    @State private var tinkoff: Bool = false
    @State private var other: Bool = false
    
    @Binding private var path: NavigationPath
    @Binding private var showTabBar: Bool

    private let step: Double
    
    public init(model: Model, path: Binding<NavigationPath>, step: Double, showTabBar: Binding<Bool>) {
        self._model = ObservedObject(wrappedValue: model)
        self._path = path
        self.step = step
        self._showTabBar = showTabBar
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            back
            VStack(alignment: .leading, spacing: Constants.defSpacing) {
                VStack (alignment: .leading) {
                    Text("Последний рывок")
                        .font(Fonts.small)
                        .foregroundColor(.black)
                    Text("В каких компаниях ты хочешь работать?")
                        .font(Fonts.heading)
                        .foregroundColor(.black)
                }
                specListView
            }
            .padding(.top, Constants.topPadding)
            Spacer()
            VStack(spacing: Constants.defSpacing) {
                ProgressView(value: step/model.stepsCount)
                    .padding(.horizontal, 20)
                    .tint(Color(.accent))
                    .scaleEffect(x: 1, y: 3, anchor: .center)
                button
            }
            
        }
        .padding(.horizontal, Constants.horizontal)
        .padding(.bottom, Constants.bottom)
    }
    
    
    var specListView: some View {
        VStack (alignment: .leading, spacing: Constants.defSpacing) {
            HStack(spacing: Constants.smallStack) {
                CheckboxView(isOn: $tinkoff)
                Text("Тинькофф")
                    .font(Fonts.main)
            }
            HStack(spacing: Constants.smallStack) {
                CheckboxView(isOn: $yandex)
                Text("Яндекс")
                    .font(Fonts.main)
            }
            HStack(spacing: Constants.smallStack) {
                CheckboxView(isOn: $other)
                Text("Другое")
                    .font(Fonts.main)
            }
        }
    }
    
    var back: some View {
        BackButton(onTap: {})
    }
    
    func updateComp() {
        var array: [Companies] = []
        if yandex {
            array.append(.yandex)
        }
        if tinkoff {
            array.append(.tinkoff)
        }
        if other {
            array.append(.other)
        }
        model.updateCompanies(comps: array)
    }
    
    var button: some View {
        MainButton(action: {
            if yandex || tinkoff || other {
                updateComp()
                model.saveInfo()
                //TODO: как-то вернуться к корню
                path = NavigationPath()
            } else {
                
            }
        }, label: "Закончили!")
    }
}

