import SwiftUI
import UIComponents
import Types

enum Page {
    case chats
    case search
}

public struct ChatsView<Model: ChatViewModel>: View {
    @StateObject private var model: Model
    @State private var presentDetailChat: Bool = false
    
    @State private var input: String = ""
    @FocusState private var isFocused: Bool
    
    @State private var filterPresent: Bool = false
    @State private var filterIsOn: Bool = false
    
    @State private var page: Page = .chats
    
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
                switch page {
                case .chats:
                    chats
                case .search:
                    search
                }
                Spacer()
            }
            .navigationDestination(isPresented: $filterPresent, destination: {
                FilterView(model: model, showTabBar: $showTabBar)
                    .navigationBarBackButtonHidden()
            })
            .onAppear {
                model.onViewAppear()
            }
            .padding(.horizontal, Constants.horizontal)
            .padding(.bottom, Constants.horizontal)
        }
    }
    
    var filteredItems: [Profile] {
        return model.profiles.filter { item in
            input.isEmpty || item.name.lowercased().contains(input.lowercased())
        }
    }
    
    var search: some View {
        VStack(spacing: Constants.defSpacing) {
            searchTextField
            ScrollView {
                VStack(spacing: Constants.defSpacing) {
                    ForEach(filteredItems) { profile in
                        if profile.id != model.profileId {
                            ProfileElementView(profile: profile, onChatTapped: {
                                presentDetailChat = true
                            })
                            .navigationDestination(isPresented: $presentDetailChat, destination: {
                                    ChatDetailView(showTabBar: $showTabBar, chat: model.getChatByResponderOrCreateNew(responder: profile), model: model)
                                        .navigationBarBackButtonHidden()
                            })
                        }
                    }
                }
            }
            .refreshable {}
            .scrollDismissesKeyboard(.immediately)
            .scrollIndicators(.hidden)
        }
        .transition(.move(edge: .trailing))
    }
    
    
    var searchTextField: some View {
        SearchTextFieldView(onAppear: {
            filterIsOn = model.filtersNotActive()
        }, input: $input, buttonAction: {
            filterPresent = true
        }, filterIsOn: $filterIsOn)
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
                                    .font(Fonts.mainBold)
                                    .foregroundColor(.black)
                                Text(chat.messages.last?.text ?? "")
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
        .transition(.move(edge: .leading))
        .refreshable {}
    }
    
    var select: some View {
        HStack(spacing: Constants.defSpacing) {
            VStack {
                Text("Ваши чаты")
                    .font(page == .chats ? Fonts.mainBold : Fonts.main)
                RoundedRectangle(cornerRadius: Constants.corner)
                    .foregroundColor(page == .chats ? Color(.accent) : .clear)
                    .frame(height: 3)
            }
            .onTapGesture {
                withAnimation {
                    if page != .chats {
                        page = .chats
                    }
                }
            }
            VStack {
                Text("Поиск")
                    .font(page == .search ? Fonts.mainBold : Fonts.main)
                RoundedRectangle(cornerRadius: Constants.corner)
                    .foregroundColor(page == .search ? Color(.accent) : .clear)
                    .frame(height: 3)
            }
            .onTapGesture {
                withAnimation {
                    if page != .search {
                        page = .search
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
