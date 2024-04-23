import SwiftUI
import UIComponents
import Types

public enum Levels: String {
    case inter = "Хочу попасть на стажировку"
    case jun = "Уже готов на Jun/Jun+"
    case mid = "Иду на позицию Middle/Middle+"
    case sen = "Я уже космолёт (Senior и выше)"
}

struct FillProfileLevelView<Model: ProfileViewModel>: View {

    public init(model: Model, path: Binding<NavigationPath>, step: Double, showTabBar: Binding<Bool>) {
        self._model = ObservedObject(wrappedValue: model)
        self._path = path
        self.step = step
        self._showTabBar = showTabBar
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            BackButton()
            VStack(alignment: .leading, spacing: Constants.defSpacing) {
                VStack (alignment: .leading) {
                    Text("Почти всё!")
                        .font(Fonts.small)
                        .foregroundColor(.black)
                    Text("К какому уровню ты стремишься?")
                        .font(Fonts.heading)
                        .foregroundColor(.black)
                }
                specListView
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

    @ObservedObject private var model: Model
    @State private var present: Bool = false

    @State private var inter: Bool = false
    @State private var jun: Bool = false
    @State private var mid: Bool = false
    @State private var sen: Bool = false

    @Binding private var path: NavigationPath
    @Binding private var showTabBar: Bool

    private let step: Double

    private var specListView: some View {
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
    
    private var button: some View {
        MainButton(action: {
            if inter || jun || mid || sen {
                present = true
            } else {
                
            }
        }, label: "Дальше")
            .navigationDestination(isPresented: $present) {
                FillProfileCompView(model: model, path: $path, step: step+1, showTabBar: $showTabBar)
                    .navigationBarBackButtonHidden()
            }
    }
}

