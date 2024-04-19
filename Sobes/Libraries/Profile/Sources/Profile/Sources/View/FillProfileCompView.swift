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
            VStack(alignment: .leading, spacing: 16) {
                VStack (alignment: .leading) {
                    Text("Последний рывок")
                        .font(Font.custom("CoFoSans-Regular", size: 13))
                        .foregroundColor(.black)
                    Text("В каких компаниях ты хочешь работать?")
                        .font(Font.custom("CoFoSans-Bold", size: 23))
                        .foregroundColor(.black)
                }
                specListView
            }
            .padding(.top, 20)
            Spacer()
            VStack(spacing: 16) {
                ProgressView(value: step/model.stepsCount)
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
                Text("Тинькофф")
                    .font(Font.custom("CoFoSans-Regular", size: 17))
            }
            HStack(spacing: 10) {
                CheckboxView(isOn: $isOn)
                Text("Сбер")
                    .font(Font.custom("CoFoSans-Regular", size: 17))
            }
            HStack(spacing: 10) {
                CheckboxView(isOn: $isOn)
                Text("Яндекс")
                    .font(Font.custom("CoFoSans-Regular", size: 17))
            }
            HStack(spacing: 10) {
                CheckboxView(isOn: $isOn)
                Text("Другое")
                    .font(Font.custom("CoFoSans-Regular", size: 17))
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

