import SwiftUI
import UIComponents

public struct ProfileView<Model: ProfileViewModel>: View {
    private let name: String = "Алиса Вышегородцева"
    @State private var presentSettings: Bool = false
    @State private var presentFill: Bool = false
    @ObservedObject private var model: Model
    
    public init(model: Model) {
        self._model = ObservedObject(wrappedValue: model)
    }
    
    public var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    nameView
                    Spacer()
                    settingsView
                }
                Spacer()
                emptyView
                Spacer()
                button
            }
            .padding(.horizontal, 31)
            .padding(.bottom, 31)
        }
    }
    var button: some View {
        MainButton(action: {presentFill=true}, label: "Рассказать о себе")
            .navigationDestination(isPresented: $presentFill) {
                FillProfileSpecView(model: model)
                    .navigationBarBackButtonHidden()
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
            ProfileSettingsView()
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

