import SwiftUI
import UIComponents
import Types

struct FillProfileSpecView<Model: ProfileViewModel>: View {
    @State private var present: Bool = false
    @State private var isProd: Bool = false
    @State private var isProj: Bool = false
    @State private var isAnal: Bool = false
    @Binding private var path: NavigationPath
    @Binding private var showTabBar: Bool
    
    @ObservedObject private var model: Model
    private var step: Double = 1
    
    public init(model: Model, path: Binding<NavigationPath>, showTabBar: Binding<Bool>){
        self._model = ObservedObject(wrappedValue: model)
        self._path = path
        self._showTabBar = showTabBar
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
                ProgressView(value: step/model.stepsCount)
                    .padding(.horizontal, 20)
                    .tint(Color(.accent))
                    .scaleEffect(x: 1, y: 3, anchor: .center)
                button
            }
            
        }
        .padding(.horizontal, Constants.horizontal)
        .padding(.bottom, Constants.bottom)
        .onAppear {
            showTabBar = false
        }
    }
    
    
    var specListView: some View {
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
    
    var back: some View {
        BackButton(onTap: {
            showTabBar = true
        })
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
        model.updateSpecs(specs: specArray)
    }
    
    var button: some View {
        MainButton(action: {
            if isAnal || isProd || isProj {
                updateSpecs()
                present = true
            }
        }, label: "Дальше")
        .navigationDestination(isPresented: $present) {
            FillProfileLevelView(model: model, path: $path, step: step+1, showTabBar: $showTabBar)
                .navigationBarBackButtonHidden()
        }
    }
}
