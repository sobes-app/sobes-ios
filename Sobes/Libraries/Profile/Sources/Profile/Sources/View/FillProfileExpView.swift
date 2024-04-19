//
//  SwiftUIView.swift
//
//
//  Created by Алиса Вышегородцева on 19.04.2024.
//

import SwiftUI
import UIComponents

public struct FillProfileExpView<Model: ProfileViewModel>: View {
    @ObservedObject private var model: Model
    @State private var present: Bool = false
    @State private var isOn: Bool = false
    @Binding private var rootIsPresented: Bool
    
    public init(model: Model, root: Binding<Bool>) {
        self._rootIsPresented = root
        self._model = ObservedObject(wrappedValue: model)
        DispatchQueue.main.async {
            model.step += 1
        }
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            back
            VStack(alignment: .leading, spacing: 16) {
                //TODO: починить дисмисс
                Text("Выбери свой уровень для профессии “\(model.specs[Int(model.step) - 1].rawValue)”")
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
                if model.step == model.stepsCount - 2 {
                    FillProfileLevelView(model: model, root: $rootIsPresented)
                        .navigationBarBackButtonHidden()
                } else {
                    FillProfileExpView(model: model, root: $rootIsPresented)
                        .navigationBarBackButtonHidden()
                }
            }
    }
}
