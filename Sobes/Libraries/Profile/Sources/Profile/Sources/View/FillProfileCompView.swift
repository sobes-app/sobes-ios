//
//  SwiftUIView.swift
//
//
//  Created by Алиса Вышегородцева on 19.04.2024.
//

import SwiftUI
import UIComponents

struct FillProfileCompView<Model: ProfileViewModel>: View {
    @ObservedObject private var model: Model
    @State private var isOn: Bool = false
    @Binding private var rootIsPresented: Bool
    private let step: Double
    
    public init(model: Model, root: Binding<Bool>, step: Double) {
        self._model = ObservedObject(wrappedValue: model)
        self._rootIsPresented = root
        self.step = step
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
                CheckboxView(isOn: $isOn)
                Text("Тинькофф")
                    .font(Fonts.main)
            }
            HStack(spacing: Constants.smallStack) {
                CheckboxView(isOn: $isOn)
                Text("Сбер")
                    .font(Fonts.main)
            }
            HStack(spacing: Constants.smallStack) {
                CheckboxView(isOn: $isOn)
                Text("Яндекс")
                    .font(Fonts.main)
            }
            HStack(spacing: Constants.smallStack) {
                CheckboxView(isOn: $isOn)
                Text("Другое")
                    .font(Fonts.main)
            }
        }
    }
    
    var back: some View {
        BackButton(onTap: {})
    }
    
    var button: some View {
        MainButton(action: {
            if isOn {
                model.saveInfo()
                //TODO: как-то вернуться к корню
                rootIsPresented = false
            } else {
                
            }
        }, label: "Закончили!")
    }
}

