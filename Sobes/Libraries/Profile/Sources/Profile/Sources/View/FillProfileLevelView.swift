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
    
    public init(model: Model, root: Binding<Bool>) {
        self._model = ObservedObject(wrappedValue: model)
        self._rootIsPresented = root
        DispatchQueue.main.async {
            model.step += 1
        }
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            back
            VStack(alignment: .leading, spacing: 16) {
                VStack (alignment: .leading) {
                    Text("Почти всё!")
                        .font(Font.custom("CoFoSans-Regular", size: 13))
                        .foregroundColor(.black)
                    Text("К какому уровню ты стремишься?")
                        .font(Font.custom("CoFoSans-Bold", size: 23))
                        .foregroundColor(.black)
                }
                specListView
            }
            .padding(.top, 20)
            Spacer()
            VStack(spacing: 16) {
                ProgressView(value: model.step/model.stepsCount)
                    .padding(.horizontal, 20)
                    .tint(Color(.accent))
                    .scaleEffect(x: 1, y: 3, anchor: .center)
                button
            }
            
        }
        .padding(.horizontal, 31)
        .padding(.bottom, 53)
    }

    
    var specListView: some View {
        VStack (alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                CheckboxView(isOn: $isOn)
                Text("Хочу попасть на стажировку")
                    .font(Font.custom("CoFoSans-Regular", size: 17))
            }
            HStack(spacing: 10) {
                CheckboxView(isOn: $isOn)
                Text("Уже готов на Jun/Jun+")
                    .font(Font.custom("CoFoSans-Regular", size: 17))
            }
            HStack(spacing: 10) {
                CheckboxView(isOn: $isOn)
                Text("Иду на позицию Middle/Middle+")
                    .font(Font.custom("CoFoSans-Regular", size: 17))
            }
            HStack(spacing: 10) {
                CheckboxView(isOn: $isOn)
                Text("Я уже космолёт (Senior и выше)")
                    .font(Font.custom("CoFoSans-Regular", size: 17))
            }
        }
    }
    
    var back: some View {
        BackButton(onTap: {model.step -= 1})
    }
    
    var button: some View {
        MainButton(action: {
            if isOn {
                present = true
            } else {
                
            }
        }, label: "Дальше")
            .navigationDestination(isPresented: $present) {
                FillProfileCompView(model: model, root: $rootIsPresented)
                    .navigationBarBackButtonHidden()
            }
    }
}

