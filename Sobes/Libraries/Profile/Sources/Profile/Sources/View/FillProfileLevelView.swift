//
//  SwiftUIView.swift
//  
//
//  Created by Алиса Вышегородцева on 19.04.2024.
//

import SwiftUI
import UIComponents

struct FillProfileLevelView: View {
    @State private var present: Bool = false
    @State private var isOn: Bool = false
    private let steps: Double
    private let step: Double
    
    public init(steps: Double = 0.0, step: Double = 0.0) {
        self.steps = steps
        self.step = step
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            back
            VStack(alignment: .leading, spacing: 16) {
                VStack {
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
                ProgressView(value: step/steps)
                    .padding(.horizontal, 20)
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
        BackButton()
    }
    
    var button: some View {
        MainButton(action: {present = true}, label: "Дальше")
            .navigationDestination(isPresented: $present) {
                FillProfileCompView()
                    .navigationBarBackButtonHidden()
            }
    }
}

#Preview {
    FillProfileLevelView(steps: 2)
}
