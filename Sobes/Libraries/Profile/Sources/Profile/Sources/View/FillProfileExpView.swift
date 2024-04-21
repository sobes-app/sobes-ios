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
    @State private var noExp: Bool = false
    @State private var lessYear: Bool = false
    @State private var moreYear: Bool = false
    @Binding private var path: NavigationPath
    @Binding private var showTabBar: Bool

    private var step: Double
    
    public init(model: Model, path: Binding<NavigationPath>, step: Double, showTabBar: Binding<Bool>) {
        self._path = path
        self._model = ObservedObject(wrappedValue: model)
        self.step = step
        self._showTabBar = showTabBar
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            back
            VStack(alignment: .leading, spacing: Constants.defSpacing) {
                Text("Выбери свой уровень для профессии “\(model.getCurrentSpec(ind: step))”")
                    .font(Fonts.heading)
                    .foregroundColor(.black)
                specListView
                Text("Если у тебя был рабочий опыт по этой профессии, то указывай его. Если рабочего опыта не было, укажи, какое время ты уже занимаешься задачами, схожими с задачами этой профессии")
                    .font(Fonts.small)
                    .foregroundColor(Color("grey", bundle: .module))
                
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
                CheckboxView(isOn: $noExp, onTap: {
                    lessYear = false
                    moreYear = false
                })
                Text("Не было опыта")
                    .font(Fonts.main)
            }
            HStack(spacing: Constants.smallStack) {
                CheckboxView(isOn: $lessYear, onTap: {
                    noExp = false
                    moreYear = false
                })
                Text("Был релевантный опыт до года")
                    .font(Fonts.main)
            }
            HStack(spacing: Constants.smallStack) {
                CheckboxView(isOn: $moreYear, onTap: {
                    noExp = false
                    lessYear = false
                })
                Text("Бал релевантный опыт более года")
                    .font(Fonts.main)
            }
        }
    }
    
    var back: some View {
        BackButton(onTap: {})
    }
    
    var button: some View {
        MainButton(action: {
            if noExp || lessYear || moreYear {
                present = true
            } else {
                
            }
        }, label: "Дальше")
            .navigationDestination(isPresented: $present) {
                if step == model.stepsCount - 2 {
                    FillProfileLevelView(model: model, path: $path, step: step+1, showTabBar: $showTabBar)
                        .navigationBarBackButtonHidden()
                } else {
                    FillProfileExpView(model: model, path: $path, step: step+1, showTabBar: $showTabBar)
                        .navigationBarBackButtonHidden()
                }
            }
    }
}
