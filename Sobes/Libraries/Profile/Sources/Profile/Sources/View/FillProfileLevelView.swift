//
//  SwiftUIView.swift
//  
//
//  Created by Алиса Вышегородцева on 19.04.2024.
//

import SwiftUI
import UIComponents

struct FillProfileLevelView<Model: ProfileViewModel>: View {
    @ObservedObject private var model: Model
    @State private var present: Bool = false
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
                    Text("Почти всё!")
                        .font(Fonts.small)
                        .foregroundColor(.black)
                    Text("К какому уровню ты стремишься?")
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
                Text("Хочу попасть на стажировку")
                    .font(Fonts.main)
            }
            HStack(spacing: Constants.smallStack) {
                CheckboxView(isOn: $isOn)
                Text("Уже готов на Jun/Jun+")
                    .font(Fonts.main)
            }
            HStack(spacing: Constants.smallStack) {
                CheckboxView(isOn: $isOn)
                Text("Иду на позицию Middle/Middle+")
                    .font(Fonts.main)
            }
            HStack(spacing: Constants.smallStack) {
                CheckboxView(isOn: $isOn)
                Text("Я уже космолёт (Senior и выше)")
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
                present = true
            } else {
                
            }
        }, label: "Дальше")
            .navigationDestination(isPresented: $present) {
                FillProfileCompView(model: model, root: $rootIsPresented, step: step+1)
                    .navigationBarBackButtonHidden()
            }
    }
}

