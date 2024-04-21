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
    @Binding private var rootIsPresented: Bool
    
    @ObservedObject private var model: Model
    private var step: Double = 0
        
    public init(model: Model, root: Binding<Bool>){
        self._model = ObservedObject(wrappedValue: model)
        self._rootIsPresented = root
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            back
            VStack(alignment: .leading, spacing: Constants.defSpacing) {
                Text("Какие профессии тебя интересуют?")
                    .font(Fonts.heading)
                    .foregroundColor(.black)
                specListView
            }
            .padding(.top, Constants.topPadding)
            Spacer()
            VStack(spacing: Constants.defSpacing) {
                ProgressView(value: 0)
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
                CheckboxView(isOn: $isProj)
                Text("Менеджер проекта")
                    .font(Fonts.main)
            }
            HStack(spacing: Constants.smallStack) {
                CheckboxView(isOn: $isProd)
                Text("Менеджер продукта")
                    .font(Fonts.main)
            }
            HStack(spacing: Constants.smallStack) {
                CheckboxView(isOn: $isAnal)
                Text("Бизнес аналитик")
                    .font(Fonts.main)
            }
        }
    }
    
    var back: some View {
        BackButton(onTap: {})
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
        model.stepsCount = Double(model.specs.count + 2)
    }
    
    var button: some View {
        MainButton(action: {
            if isAnal || isProd || isProj {
                present = true
                countSteps()
            }
        }, label: "Дальше")
            .navigationDestination(isPresented: $present) {
                FillProfileExpView(model: model, root: $rootIsPresented, step: step+1)
                    .navigationBarBackButtonHidden()
            }
    }
}
