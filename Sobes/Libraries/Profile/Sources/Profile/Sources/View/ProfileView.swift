import SwiftUI
import UIComponents
import Authorization

public struct ProfileView<Model: ProfileViewModel>: View {
    @EnvironmentObject var auth: Authentication
    
    @State private var presentSettings: Bool = false
    @State private var presentFill: Bool = false
    @State private var presentFeedback: Bool = false
    @State private var presentVacancies: Bool = false
    
    @State private var path = NavigationPath()
    @StateObject private var model: Model
    @Binding private var showTabBar: Bool
    
    @State private var profileParam: Question = .companies
    @State private var editParam: Bool = false
    
    public init(model: Model, showTabBar: Binding<Bool>) {
        self._model = StateObject(wrappedValue: model)
        self._showTabBar = showTabBar
    }
    
    public var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                VStack(alignment: .leading) {
                    HStack(alignment: .top, spacing: Constants.smallStack) {
                        nameView
                        Spacer()
                        settingsView
                        logoutView
                    }
                    if !model.getProfileLevel().isEmpty {
                        statsView
                        Spacer()
                    } else {
                        Spacer()
                        EmptyDataView(text: "Расскажите нам о себе")
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        feedbackButton
                            .padding(.bottom, Constants.defSpacing)
                    }
                    if model.getProfileLevel().isEmpty {
                        button
                    }
                }
                .padding(.horizontal, Constants.horizontal)
                .padding(.bottom, Constants.horizontal)
                
                if model.isLoading {
                    SplashScreen()
                }
            }
            .navigationDestination(isPresented: $editParam, destination: {
                SetupProfileDataView(model: model, showTabBar: $showTabBar, question: profileParam)
                    .navigationBarBackButtonHidden()
            })
            .navigationDestination(isPresented: $presentVacancies, destination: {
                VacanciesView(model: model, showTabBar: $showTabBar)
                    .navigationBarBackButtonHidden()
            })
        }
        .onAppear {
            Task { @MainActor in
                if !(await model.onViewAppear()) {
                    auth.updateStatus(success: false)
                    model.onLogoutTap()
                }
            }
        }
    }
    
    private var feedbackButton: some View {
        Button(action: {
            presentFeedback = true
        }, label: {
            CircularTextView(title: "обратная связь * обратная связь *".uppercased(), radius: 61)
        })
        .navigationDestination(isPresented: $presentFeedback, destination: {
            FeedbackView(model: model, showTabBar: $showTabBar)
                .navigationBarBackButtonHidden()
        })
    }
    
    var button: some View {
        MainButton(action: {presentFill=true}, label: "Рассказать о себе")
            .navigationDestination(isPresented: $presentFill) {
                SetupProfileDataView(model: model, showTabBar: $showTabBar)
                    .navigationBarBackButtonHidden()
            }
    }
    
    var statsView: some View {
        VStack(alignment: .leading, spacing: Constants.defSpacing) {
            professionsView
            levelView
            companiesView
            if model.companies.contains(.other) && model.companies.count <= 1 { }
            else {
                ChevronButton(model: .button(text: "Найти подходящие вакансии"))
                    .onTapGesture {
                        presentVacancies = true
                    }
            }
            Text("Для изменения данных нажмите на нужную ячейку")
                .font(Fonts.small)
                .foregroundColor(Static.Colors.grey)
                .multilineTextAlignment(.leading)
        }
    }
    
    var companiesView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Хочет работать в:")
                .font(Fonts.mainBold)
            Text(model.createStringComp())
                .font(Fonts.main)
                .multilineTextAlignment(.leading)
        }
        .foregroundColor(Color(.accent))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Constants.elementPadding)
        .background {
            RoundedRectangle(cornerRadius: Constants.corner)
                .stroke(Color(.accent))
        }
        .onTapGesture {
            editParam = true
            profileParam = .companies
        }
    }
    
    var levelView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Желаемая позиция")
                .font(Fonts.mainBold)
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
            Text(model.getProfileLevel())
                .font(Fonts.main)
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
        }
        .padding(Constants.elementPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background{
            RoundedRectangle(cornerRadius: Constants.corner)
                .foregroundColor(Color(.accent))
        }
        .onTapGesture {
            editParam = true
            profileParam = .levels
        }
    }
    
    var professionsView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Желаемые должности:")
                .font(Fonts.mainBold)
            Text(model.createStringProf())
                .font(Fonts.main)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Constants.elementPadding)
        .background {
            RoundedRectangle(cornerRadius: Constants.corner)
                .foregroundColor(.white)
                .shadow(color: Static.Colors.grey, radius: 10)
        }.onTapGesture {
            editParam = true
            profileParam = .professions
        }
    }
    
    var nameView: some View {
        Text("Привет, ")
            .font(Fonts.mainBold)
            .foregroundColor(.black)
        + Text(model.getProfileName())
            .font(Fonts.mainBold)
            .foregroundColor(Color(.accent))
        + Text("!")
            .font(Fonts.mainBold)
            .foregroundColor(.black)
    }
    
    var settingsView: some View {
        Button(action: {presentSettings = true}) {
            Image(systemName: "gearshape.fill")
                .foregroundColor(.black)
                .padding(Constants.elementPadding)
                .background {
                    RoundedRectangle(cornerRadius: Constants.corner)
                        .foregroundColor(Color(.light))
                }
        }
        .navigationDestination(isPresented: $presentSettings) {
            ProfileSettingsView(model: model, showTabBar: $showTabBar)
                .navigationBarBackButtonHidden()
        }
    }
    
    var logoutView: some View {
        Button(action: {
            model.onLogoutTap()
            auth.updateStatus(success: false)
        }) {
            Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                .foregroundColor(.black)
                .padding(Constants.elementPadding)
                .background {
                    RoundedRectangle(cornerRadius: Constants.corner)
                        .foregroundColor(Color(.light))
                }
        }
    }
}

private enum Static {
    enum Colors {
        static let grey: Color = Color("grey", bundle: .main)
    }
}

