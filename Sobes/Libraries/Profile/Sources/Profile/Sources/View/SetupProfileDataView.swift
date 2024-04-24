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
    private var question: Question?
    
    public init(model: Model, showTabBar: Binding<Bool>, question: Question? = nil) {
        self._model = ObservedObject(wrappedValue: model)
        self._showTabBar = showTabBar
        self.question = question
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.defSpacing) {
            Spacer()
            if question != nil {
                switch question {
                case .professions:
                    professions
                        .transition(.move(edge: .trailing))
                case .levels:
                    levels
                        .transition(.move(edge: .trailing))
                case .companies:
                    companies
                        .transition(.move(edge: .trailing))
                case nil:
                    Text("")
                }
            } else {
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
            }
            Spacer()
            VStack(spacing: Constants.defSpacing) {
                ProgressView(value: step/3)
                    .padding(.horizontal, 20)
                    .tint(Color(.accent))
                    .scaleEffect(x: 1, y: 3, anchor: .center)
                    .animation(.easeInOut, value: step)
                button
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
    
    var button: some View {
        Button (action: {
            switch step {
            case 1:
                updateSpecs()
            case 2:
                break
            case 3:
                updateComp()
                model.saveInfo()
                presentationMode.wrappedValue.dismiss()
                showTabBar = true
            default:
                break
            }
            if isAvailable(step: step) {
                step += 1
                currentQuestion = Question(rawValue: Int(step)) ?? .companies
                if currentQuestion == .companies {
                    label = "Закончить!"
                }
            }
        }) {
            Text(label)
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
        switch step {
        case 1:
            if isAnal || isProd || isProj {
                return true
            }
        case 2:
            if inter || jun || mid || sen {
                return true
            }
        case 3:
            if yandex || tinkoff || other {
                return true
            }
        default:
            return false
        }
        return false
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
}
