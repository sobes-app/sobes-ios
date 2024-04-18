import SwiftUI
import UIComponents

public struct ProfileView: View {
    private let name: String = "Алиса Вышегородцева"
    @State private var presentSettings: Bool = false
    
    public init() {}
    
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
                button        }
            .padding(.horizontal, 31)
            .padding(.bottom, 31)
        }
    }
    var button: some View {
        MainButton(action: {}, label: "Рассказать о себе")
    }
    
    var emptyView: some View {
        VStack(alignment: .center) {
            Text("В вашем профиле пока пусто :(")
                .font(Font.custom("CoFoSans-Bold", size: 17))
                .foregroundColor(Color("grey", bundle: .module))
            Text("Расскажите о себе, чтобы подготовка стала продуктивнее")
                .multilineTextAlignment(.center)
                .font(Font.custom("CoFoSans-Bold", size: 17))
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
            ProfileSettingsView()
                .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    ProfileView()
}
