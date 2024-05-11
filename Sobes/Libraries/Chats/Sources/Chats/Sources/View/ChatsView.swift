import SwiftUI
import UIComponents
import Types
import SwiftUIGIF

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
                    .padding(.horizontal, Constants.horizontal)
                select
                    .padding(.horizontal, Constants.horizontal)
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
            .padding(.bottom, Constants.horizontal)
            .task {
                await model.onViewAppear()
            }
        }
    }
    
    var filteredItems: [Profile] {
        return model.profiles?.filter { item in
            input.isEmpty || item.name.lowercased().contains(input.lowercased())
        } ?? []
    }
    
    var search: some View {
        VStack(spacing: Constants.defSpacing) {
            searchTextField
            if model.isLoading {
                LoadingScreen(placeholder: "Загружаем профили...")
            } else if model.isError {
                ErrorView(retryAction: {
                    Task { @MainActor in
                        await model.getProfiles()
                    }
                })
            } else if model.profiles != [] && model.profiles != nil {
                ScrollView {
                    VStack(spacing: Constants.defSpacing) {
                        ForEach(filteredItems) { profile in
                            ProfileElementView(profile: profile, onChatTapped: {
                                if !model.checkChatExistance(responder: profile) {
                                    model.createNewChat(reponder: profile)
                                }
                                withAnimation {
                                    page = .chats
                                }
                            })
                        }
                    }
                }
                .scrollDismissesKeyboard(.immediately)
                .scrollIndicators(.hidden)
            } else {
                Spacer()
                EmptyDataView(text: "Тут пока нет профилей")
                Spacer()
            }
        }
        .padding(.horizontal, Constants.horizontal)
        .background(.white)
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
        ZStack {
            VStack(spacing: Constants.defSpacing) {
                if model.chats != [] && model.chats != nil {
                    ScrollView {
                        ForEach(model.chats ?? []) { chat in
                            NavigationLink(destination: ChatDetailView(showTabBar: $showTabBar, chat: chat, model: model)) {
                                chatView(chat: chat)
                            }
                        }
                    }
                } else {
                    Spacer()
                    EmptyDataView(text: "У вас пока нет чатов")
                    Spacer()
                }
            }
            .padding(.horizontal, Constants.horizontal)
            .background(.white)
            .transition(.move(edge: .leading))
            .refreshable {}
        }
    }
    
    func chatView(chat: Chat) -> some View {
        VStack(spacing: Constants.defSpacing) {
            HStack {
                Circle()
                    .frame(width: 50)
                    .foregroundColor(Color(.light))
                VStack(alignment: .leading, spacing: 5) {
                    Text(model.getResponder(chat: chat).name)
                        .font(Fonts.mainBold)
                        .foregroundColor(.black)
                    Text(chat.messages.last?.text ?? "")
                        .font(Fonts.small)
                        .foregroundColor(Color("grey", bundle: .module))
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            Rectangle()
                .foregroundColor(Color(.light))
                .frame(height: 1)
        }
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
