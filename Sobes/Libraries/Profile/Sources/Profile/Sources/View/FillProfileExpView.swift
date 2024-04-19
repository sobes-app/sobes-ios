//
//  SwiftUIView.swift
//
//
//  Created by Алиса Вышегородцева on 19.04.2024.
//

import SwiftUI
import UIComponents

public struct FillProfileExpView: View {
    @State private var present: Bool = false
    @State private var isOn: Bool = false
    private let steps: Double
    private let step: Double
    private let spec: [Spec]
    
    public init(steps: Double = 0.0, spec: [Spec], step: Double = 0.0) {
        self.steps = steps
        self.spec = spec
        self.step = step
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            back
            VStack(alignment: .leading, spacing: 16) {
                Text("Выбери свой уровень для профессии “\(spec[Int(step)-1].rawValue)”")
                    .font(Font.custom("CoFoSans-Bold", size: 23))
                    .foregroundColor(.black)
                specListView
                Text("Если у тебя был рабочий опыт по этой профессии, то указывай его. Если рабочего опыта не было, укажи, какое время ты уже занимаешься задачами, схожими с задачами этой профессии")
                    .font(Font.custom("CoFoSans-regular", size: 13))
                    .foregroundColor(Color("grey", bundle: .module))
                
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
                Text("Не было опыта")
                    .font(Font.custom("CoFoSans-Regular", size: 17))
            }
            HStack(spacing: 10) {
                CheckboxView(isOn: $isOn)
                Text("Был релевантный опыт до года")
                    .font(Font.custom("CoFoSans-Regular", size: 17))
            }
            HStack(spacing: 10) {
                CheckboxView(isOn: $isOn)
                Text("Бал релевантный опыт более года")
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
                if step == steps - 2 {
                    FillProfileLevelView(steps: steps, step: step+1)
                        .navigationBarBackButtonHidden()
                } else {
                    FillProfileExpView(steps: steps, spec: spec, step: step+1)
                        .navigationBarBackButtonHidden()
                }
            }
    }
}
