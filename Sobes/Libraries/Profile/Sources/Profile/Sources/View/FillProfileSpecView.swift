//
//  SwiftUIView.swift
//
//
//  Created by Алиса Вышегородцева on 19.04.2024.
//

import SwiftUI
import UIComponents

public enum Spec: String {
    case product = "Менеджер продукта"
    case project = "Менеджер проекта"
    case analyst = "Бизнес аналитик"
}

struct FillProfileSpecView<Model: ProfileViewModel>: View {
    @State private var present: Bool = false
    @State private var isProd: Bool = false
    @State private var isProj: Bool = false
    @State private var isAnal: Bool = false
    
    @ObservedObject private var model: Model
    
    private let progress = 0.0
    
    public init(model: Model){
        self._model = ObservedObject(wrappedValue: model)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            back
            VStack(alignment: .leading, spacing: 16) {
                Text("Какие профессии тебя интересуют?")
                    .font(Font.custom("CoFoSans-Bold", size: 23))
                    .foregroundColor(.black)
                specListView
            }
            .padding(.top, 20)
            Spacer()
            VStack(spacing: 16) {
                ProgressView(value: progress)
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
                CheckboxView(isOn: $isProj)
                Text("Менеджер проекта")
                    .font(Font.custom("CoFoSans-Regular", size: 17))
            }
            HStack(spacing: 10) {
                CheckboxView(isOn: $isProd)
                Text("Менеджер продукта")
                    .font(Font.custom("CoFoSans-Regular", size: 17))
            }
            HStack(spacing: 10) {
                CheckboxView(isOn: $isAnal)
                Text("Бизнес аналитик")
                    .font(Font.custom("CoFoSans-Regular", size: 17))
            }
        }
    }
    
    var back: some View {
        BackButton()
    }
    
    func countSteps() {
        var specArray: [Spec] = []
        if isAnal {
            specArray.append(.analyst)
        }
        if isProd {
            specArray.append(.product)
        }
        if isProj {
            specArray.append(.project)
        }
        model.updateSpecs(specs: specArray)
    }
    
    var button: some View {
        MainButton(action: {
            if isAnal || isProd || isProj {
                present = true
            }
            countSteps()
        }, label: "Дальше")
            .navigationDestination(isPresented: $present) {
                FillProfileExpView(steps: Double(model.specs.count + 2), spec: model.specs, step: 1)
                    .navigationBarBackButtonHidden()
            }
    }
}