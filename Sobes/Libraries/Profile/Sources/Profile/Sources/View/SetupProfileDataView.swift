//
//  SwiftUIView.swift
//
//
//  Created by Алиса Вышегородцева on 23.04.2024.
//

import SwiftUI
import UIComponents
import Types
import Combine

enum Question: Int {
    case professions = 1
    case levels = 2
    case companies = 3
}

struct SetupProfileDataView<Model: ProfileViewModel>: View {
    @ObservedObject private var model: Model
    @Binding private var showTabBar: Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var currentQuestion: Question = .professions
    @State private var step: Double = 1
    @State private var label: String = "Дальше"
    
    private let stepsCount: Double
    
    public init(model: Model, showTabBar: Binding<Bool>, question: Question? = nil) {
        self._model = ObservedObject(wrappedValue: model)
        self._showTabBar = showTabBar
        self.currentQuestion = question ?? .professions
        if question != nil {
            self.stepsCount = 1
        } else {
            self.stepsCount = 3
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.defSpacing) {
            backButton
            switch currentQuestion {
            case .professions:
                professions
                    .transition(.move(edge: .trailing))
            case .levels:
                levels
                    .transition(.move(edge: .trailing))
            case .companies:
                companies
                    .transition(.move(edge: .trailing))
            }
            Spacer()
            VStack(spacing: Constants.defSpacing) {
                if stepsCount != 1 {
                    ProgressView(value: step/(stepsCount))
                        .padding(.horizontal, 20)
                        .tint(Color(.accent))
                        .scaleEffect(x: 1, y: 3, anchor: .center)
                        .animation(.easeInOut, value: step)
                }
                VStack {
                    if incorrect {
                        IncorrectView(text: "ошибка сохранения данных")
                    }
                    button
                }
            }
            
        }
        .padding(.horizontal, Constants.horizontal)
        .padding(.bottom, Constants.bottom)
        .onAppear {
            withoutAnimation {
                showTabBar = false
            }
        }
    }
    
    var backButton: some View {
        BackButton(onTap: {
            if step == 1 {
                presentationMode.wrappedValue.dismiss()
                withAnimation {
                    showTabBar = true
                }
            } else {
                step -= 1
                currentQuestion = Question(rawValue: Int(step)) ?? .companies
            }
        })
    }
    
    var button: some View {
        Button (action: {
            buttonPressed()
        }) {
            Text(stepsCount == 3 ? label : "Сохранить")
                .bold()
                .font(Fonts.mainBold)
                .foregroundColor(.white)
                .padding(.vertical, Constants.elementPadding)
                .frame(maxWidth: .infinity)
            
        }.background {
            RoundedRectangle(cornerRadius: Constants.corner)
                .foregroundColor(Color(.accent))
        }
        .padding(.horizontal, 20)
    }
    
    var professions: some View {
        VStack(alignment: .leading, spacing: Constants.defSpacing) {
            Text("Какие профессии тебя интересуют?")
                .font(Fonts.heading)
                .foregroundColor(.black)
            VStack (alignment: .leading, spacing: Constants.defSpacing) {
                HStack(spacing: Constants.smallStack) {
                    CheckboxView(isOn: $isProj)
                    Text(Professions.project.rawValue)
                        .font(Fonts.main)
                }
                HStack(spacing: Constants.smallStack) {
                    CheckboxView(isOn: $isProd)
                    Text(Professions.product.rawValue)
                        .font(Fonts.main)
                }
                HStack(spacing: Constants.smallStack) {
                    CheckboxView(isOn: $isAnal)
                    Text(Professions.analyst.rawValue)
                        .font(Fonts.main)
                }
            }
        }
    }
    
    
    var levels: some View {
        VStack(alignment: .leading, spacing: Constants.defSpacing) {
            VStack (alignment: .leading) {
                Text("Почти всё!")
                    .font(Fonts.small)
                    .foregroundColor(.black)
                Text("К какому уровню ты стремишься?")
                    .font(Fonts.heading)
                    .foregroundColor(.black)
            }
            VStack (alignment: .leading, spacing: Constants.defSpacing) {
                HStack(spacing: Constants.smallStack) {
                    CheckboxView(isOn: $inter, onTap: {
                        jun = false
                        mid = false
                        sen = false
                        model.level = Types.Levels.inter
                    })
                    Text(Levels.inter.rawValue)
                        .font(Fonts.main)
                }
                HStack(spacing: Constants.smallStack) {
                    CheckboxView(isOn: $jun, onTap: {
                        inter = false
                        mid = false
                        sen = false
                        model.level = Types.Levels.jun
                    })
                    Text(Levels.jun.rawValue)
                        .font(Fonts.main)
                }
                HStack(spacing: Constants.smallStack) {
                    CheckboxView(isOn: $mid, onTap: {
                        inter = false
                        jun = false
                        sen = false
                        model.level = Types.Levels.mid
                    })
                    Text(Levels.mid.rawValue)
                        .font(Fonts.main)
                }
                HStack(spacing: Constants.smallStack) {
                    CheckboxView(isOn: $sen, onTap: {
                        inter = false
                        jun = false
                        mid = false
                        model.level = Types.Levels.sen
                    })
                    Text(Levels.sen.rawValue)
                        .font(Fonts.main)
                }
            }
        }
    }
    
    var companies: some View {
        VStack(alignment: .leading, spacing: Constants.defSpacing) {
            VStack (alignment: .leading) {
                Text("Последний рывок")
                    .font(Fonts.small)
                    .foregroundColor(.black)
                Text("В каких компаниях ты хочешь работать?")
                    .font(Fonts.heading)
                    .foregroundColor(.black)
            }
            VStack (alignment: .leading, spacing: Constants.defSpacing) {
                HStack(spacing: Constants.smallStack) {
                    CheckboxView(isOn: $tinkoff)
                    Text("Тинькофф")
                        .font(Fonts.main)
                }
                HStack(spacing: Constants.smallStack) {
                    CheckboxView(isOn: $yandex)
                    Text("Яндекс")
                        .font(Fonts.main)
                }
                HStack(spacing: Constants.smallStack) {
                    CheckboxView(isOn: $other)
                    Text("Другое")
                        .font(Fonts.main)
                }
            }
        }
    }
    
    func updateSpecs() {
        var specArray: [Professions] = []
        if isAnal {
            specArray.append(.analyst)
        }
        if isProd {
            specArray.append(.product)
        }
        if isProj {
            specArray.append(.project)
        }
        model.professions = specArray
    }
    
    func updateComp() {
        var array: [Companies] = []
        if yandex {
            array.append(.yandex)
        }
        if tinkoff {
            array.append(.tinkoff)
        }
        if other {
            array.append(.other)
        }
        model.companies = array
    }
    
    func isAvailable(step: Double) -> Bool {
        switch currentQuestion {
        case .professions:
            if isAnal || isProd || isProj {
                return true
            }
        case .levels:
            if inter || jun || mid || sen {
                return true
            }
        case .companies:
            if yandex || tinkoff || other {
                return true
            }
        }
        return false
    }
    
    func buttonPressed() {
        switch currentQuestion {
        case .professions:
            updateSpecs()
        case .levels:
            break
        case .companies:
            updateComp()
        }
        if isAvailable(step: step) {
            if step == stepsCount {
                if stepsCount == 3 {
                    createProfile()
                } else {
                    updateProfile()
                }
            } else {
                step += 1
                currentQuestion = Question(rawValue: Int(step)) ?? .companies
                if step == stepsCount {
                    label = "Закончить!"
                }
            }
        }
    }
    
    func createProfile() {
        Task { @MainActor in
            let success = await model.setProfileInfo()
            if success {
                presentationMode.wrappedValue.dismiss()
                showTabBar = true
            } else {
                showIncorrect()
            }
        }
    }
    
    func updateProfile() {
        Task { @MainActor in
            var success = true
            switch currentQuestion {
            case .professions:
                success = await model.updateProfile(level: nil, professions: Profile.stringArrayProf(of: model.professions), companies: nil)
            case .levels:
                success = await model.updateProfile(level: model.level.rawValue, professions: nil, companies: nil)
            case .companies:
                success = await model.updateProfile(level: nil, professions: nil, companies: Profile.stringArrayComp(of: model.companies))
            }
            if success {
                presentationMode.wrappedValue.dismiss()
                withAnimation {
                    showTabBar = true
                }
            } else {
                showIncorrect()
            }
        }
    }
    
    func showIncorrect() {
        withAnimation {
            incorrect = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            withAnimation {
                incorrect = false
            }
        })
    }
    
    @State private var isProd: Bool = false
    @State private var isProj: Bool = false
    @State private var isAnal: Bool = false
    
    @State private var yandex: Bool = false
    @State private var tinkoff: Bool = false
    @State private var other: Bool = false
    
    @State private var inter: Bool = false
    @State private var jun: Bool = false
    @State private var mid: Bool = false
    @State private var sen: Bool = false
    
    @State private var incorrect: Bool = false
}
