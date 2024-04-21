import SwiftUI
import UIComponents

public struct ProfileView<Model: ProfileViewModel>: View {
    private let name: String = "Алиса Вышегородцева"
    @State private var presentSettings: Bool = false
    @State private var presentFill: Bool = false
    @State private var rootIsPresented: Bool = true
    @ObservedObject private var model: Model
    
    public init(model: Model) {
        self._model = ObservedObject(wrappedValue: model)
    }
    
    public var body: some View {
        NavigationStack{
            VStack(alignment: .leading) {
                HStack(spacing: Constants.smallStack) {
                    nameView
                    Spacer()
                    settingsView
                    logoutView
                }
                if model.savedSpecs != [] {
                    statsView
                    Spacer()
                } else {
                    Spacer()
                    emptyView
                    Spacer()
                    button
                }
            }
            .padding(.horizontal, Constants.horizontal)
            .padding(.bottom, Constants.horizontal)
        }
    }
    var button: some View {
        MainButton(action: {presentFill=true}, label: "Рассказать о себе")
            .navigationDestination(isPresented: $presentFill) {
                FillProfileSpecView(model: model, root: $rootIsPresented)
                    .navigationBarBackButtonHidden()
            }
    }
    
    var statsView: some View {
        VStack(alignment: .leading, spacing: Constants.defSpacing) {
            specsView
            HStack(spacing: Constants.defSpacing) {
                expView
                levelView
            }
            companiesView
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
            Text("пупупу пук пук пупупу")
                .font(Fonts.main)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Constants.elementPadding)
        .background {
            RoundedRectangle(cornerRadius: Constants.corner)
                .foregroundColor(Color(.light))
        }
    }
    
    var expView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Опыт")
                .font(Fonts.mainBold)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color(.accent))
            Text("пук пук")
                .font(Fonts.main)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color(.accent))
        }
        .padding(Constants.elementPadding)
        .background{
            RoundedRectangle(cornerRadius: Constants.corner)
                .stroke(Color(.accent))
        }
    }
    
    var levelView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Желаемая позиция")
                .font(Fonts.mainBold)
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
            Text("пук пук пук пук")
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
    }
    
    var specsView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Желаемые должности:")
                .font(Fonts.mainBold)
            Text(model.createString())
                .font(Fonts.main)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Constants.elementPadding)
        .background {
            RoundedRectangle(cornerRadius: Constants.corner)
                .foregroundColor(Color(.light))
        }
    }
    
    var emptyView: some View {
        VStack(alignment: .center) {
            Text("В вашем профиле пока пусто :(")
                .font(Fonts.mainBold)
                .foregroundColor(Static.Colors.grey)
            Text("Расскажите о себе, чтобы подготовка стала продуктивнее")
                .multilineTextAlignment(.center)
                .font(Fonts.main)
                .foregroundColor(Static.Colors.grey)
        }
        .frame(maxWidth: .infinity)
    }
    
    var nameView: some View {
        Text("Привет, ")
            .font(Fonts.heading)
            .foregroundColor(.black)
        + Text(name)
            .font(Fonts.heading)
            .foregroundColor(Color(.accent))
        + Text("!")
            .font(Fonts.heading)
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
            //TODO: почему боттом бар остается при переключении?
            ProfileSettingsView(model: model)
                .navigationBarBackButtonHidden()
        }
    }
    
    var logoutView: some View {
        Button(action: {
            model.onLogoutTap()
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

