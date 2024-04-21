import SwiftUI
import UIComponents



public struct ChatsView<Model: ChatViewModel>: View {
    @StateObject private var model: Model
    
    @State private var presentSearch: Bool = false
    @State private var presentChats: Bool = true
    
    @State private var detailIsPresented: Bool = false
    
    @Binding private var showTabBar: Bool
    
    public init(showTabBar: Binding<Bool>, model: Model) {
        self._showTabBar = showTabBar
        self._model = StateObject(wrappedValue: model)
    }
    
    public var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: Constants.defSpacing) {
                Text("Чаты")
                    .font(Fonts.heading)
                    .foregroundColor(.black)
                select
                if presentChats {
                    chats
                } else {
                    
                }
                Spacer()
                
            }
            .onAppear {
                model.onViewAppear()
            }
            .padding(.horizontal, Constants.horizontal)
            .padding(.bottom, Constants.horizontal)
        }
    }
    
    var chats: some View {
        ScrollView {
            ForEach(model.chats) { chat in
                NavigationLink(destination: ChatDetailView(showTabBar: $showTabBar,
                                                           chat: chat,
                                                           model: model)) {
                    VStack(spacing: Constants.defSpacing) {
                        HStack(spacing: Constants.defSpacing) {
                            Circle()
                                .stroke(Color(.accent))
                                .frame(width: 45, height: 45)
                                .foregroundColor(Color(.light))
                            VStack(alignment: .leading, spacing: 5) {
                                Text(model.getResponder(chat: chat).name)
                                    .font(Fonts.small.bold())
                                    .foregroundColor(.black)
                                Text(model.getLastMessage(chat: chat))
                                    .font(Fonts.small)
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Rectangle()
                            .foregroundColor(Color(.light))
                            .frame(height: 1)
                    }
                }
            }
        }
        .scrollClipDisabled()
    }
    
    var select: some View {
        HStack(spacing: 16) {
            VStack {
                Text("Ваши чаты")
                    .font(presentChats ? Fonts.mainBold : Fonts.main)
                    .onTapGesture {
                        presentChats = true
                        presentSearch = false
                    }
                RoundedRectangle(cornerRadius: Constants.corner)
                    .foregroundColor(presentChats ? Color(.accent) : .clear)
                    .frame(height: 3)
            }
            VStack {
                Text("Поиск")
                    .font(presentSearch ? Fonts.mainBold : Fonts.main)
                    .onTapGesture {
                        presentChats = false
                        presentSearch = true
                    }
                RoundedRectangle(cornerRadius: Constants.corner)
                    .foregroundColor(presentSearch ? Color(.accent) : .clear)
                    .frame(height: 3)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
