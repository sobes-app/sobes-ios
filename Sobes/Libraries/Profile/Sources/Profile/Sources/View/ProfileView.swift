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
                HStack(spacing: 10) {
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
            .padding(.horizontal, 31)
            .padding(.bottom, 31)
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
        VStack(alignment: .leading, spacing: 16) {
            specsView
            HStack(spacing: 16) {
                expView
                levelView
            }
            companiesView
            Text("Для изменения данных нажмите на нужную ячейку")
                .font(Font.custom("CoFoSans-Regular", size: 13))
                .foregroundColor(Color("grey", bundle: .module))
                .multilineTextAlignment(.leading)
        }
    }
    
    var companiesView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Хочет работать в:")
                .font(Font.custom("CoFoSans-Bold", size: 17))
            Text("пупупу пук пук пупупу")
                .font(Font.custom("CoFoSans-Regular", size: 17))
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(.light))
        }
    }
    
    var expView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Опыт")
                .font(Font.custom("CoFoSans-Bold", size: 17))
                .multilineTextAlignment(.leading)
                .foregroundColor(Color(.accent))
            Text("пук пук")
                .font(Font.custom("CoFoSans-Regular", size: 17))
                .multilineTextAlignment(.leading)
                .foregroundColor(Color(.accent))
        }
        .padding(15)
        .background{
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.accent))
        }
    }
    
    var levelView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Желаемая позиция")
                .font(Font.custom("CoFoSans-Bold", size: 17))
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
            Text("пук пук пук пук")
                .font(Font.custom("CoFoSans-Regular", size: 17))
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background{
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(.accent))
        }
    }
    
    var specsView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Желаемые должности:")
                .font(Font.custom("CoFoSans-Bold", size: 17))
            Text(model.createString())
                .font(Font.custom("CoFoSans-Regular", size: 17))
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(.light))
        }
    }
    
    var emptyView: some View {
        VStack(alignment: .center) {
            Text("В вашем профиле пока пусто :(")
                .font(Font.custom("CoFoSans-Bold", size: 17))
                .foregroundColor(Color("grey", bundle: .module))
            Text("Расскажите о себе, чтобы подготовка стала продуктивнее")
                .multilineTextAlignment(.center)
                .font(Font.custom("CoFoSans-Regular", size: 17))
                .foregroundColor(Color("grey", bundle: .module))
        }
        .frame(maxWidth: .infinity)
    }
    
    var nameView: some View {
        Text("Привет, ")
            .font(Font.custom("CoFoSans-Bold", size: 23))
            .foregroundColor(.black)
        + Text(name)
            .font(Font.custom("CoFoSans-Bold", size: 23))
            .foregroundColor(Color(.accent))
        + Text("!")
            .font(Font.custom("CoFoSans-Bold", size: 23))
            .foregroundColor(.black)
    }
    
    var settingsView: some View {
        Button(action: {presentSettings = true}) {
            Image(systemName: "gearshape.fill")
                .foregroundColor(.black)
                .padding(15)
                .background {
                    RoundedRectangle(cornerRadius: 10)
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
                .padding(15)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(.light))
                }
        }
    }
}

