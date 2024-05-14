import SwiftUI
import UIComponents
import Types
import SwiftUIGIF
import Foundation
import Combine

enum Page {
    case chats
    case search
}

public struct ChatsView<Model: ChatViewModel>: View {
    @StateObject private var model: Model

    @State private var presentChat: Bool = false
    @State private var input: String = ""
    @State private var chatsSearchInput: String = ""
    @State private var filterPresent: Bool = false
    @State private var filterIsOn: Bool = false
    @State private var page: Page = .chats
    
    @Binding private var showTabBar: Bool
    
    @State var chat = Chat()
    @State var chatsEmpty = false
    
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
        .onAppear {
            model.connect()
        }
    }
    
    var filteredProfiles: [Profile] {
        return model.profiles?.filter { item in
            input.isEmpty || item.name.lowercased().contains(input.lowercased())
        } ?? []
    }
    
    var filteredChats: [Chat] {
        return model.chats?.filter { item in
            chatsSearchInput.isEmpty || 
            model.getResponder(chat: item).name.lowercased().contains(chatsSearchInput.lowercased())
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
                        await model.onViewAppear()
                    }
                })
            } else if model.profiles != [] && model.profiles != nil {
                profilesScroll
            } else {
                Spacer()
                EmptyDataView(text: "Тут пока нет профилей")
                Spacer()
            }
        }
        .navigationDestination(isPresented: $presentChat, destination: {
            ChatDetailView(showTabBar: $showTabBar, chat: chat, model: model)
                .navigationBarBackButtonHidden()
        })
        .padding(.horizontal, Constants.horizontal)
        .background(.white)
        .transition(.move(edge: .trailing))
    }
    
    var profilesScroll: some View {
        ScrollView {
            VStack(spacing: Constants.defSpacing) {
                ForEach(filteredProfiles) { profile in
                    ProfileElementView(profile: profile, onChatTapped: {
                        Task {
                            chat = await model.createNewChat(responder: profile)
                            print(chat)
                            presentChat = true
                        }
                    }, chatExists: model.checkChatExistance(responder: profile))
                    .onTapGesture {
                        if model.checkChatExistance(responder: profile) {
                            chat = model.getChatByResponder(responder: profile)
                            presentChat = true
                        }
                    }
                }
            }
        }
        .refreshable {
            await model.getProfiles()
        }
        .scrollDismissesKeyboard(.immediately)
        .scrollIndicators(.hidden)
    }
    
    var searchTextField: some View {
        SearchTextFieldView(onAppear: {
            filterIsOn = model.filtersNotActive()
        }, input: $input, buttonAction: {
            filterPresent = true
        }, filterIsOn: $filterIsOn)
    }
    
    var chats: some View {
        VStack(spacing: Constants.defSpacing) {
            searchChatTextField
            if model.isLoading {
                LoadingScreen(placeholder: "Загружаем чаты...")
            } else if model.isError {
                ErrorView(retryAction: {
                    Task { @MainActor in
                        await model.onViewAppear()
                    }
                })
            } else {
                chatsScroll
            }
        }
        .padding(.horizontal, Constants.horizontal)
        .background(.white)
        .transition(.move(edge: .leading))
    }
    
    var chatsScroll: some View {
        List {
            if model.chats?.isEmpty ?? true {
                VStack {
                    Spacer()
                        .frame(height: 100)
                    EmptyDataView(text: "У вас пока нет чатов")
                }
                .listRowSeparator(.hidden)
            } else {
                ForEach(filteredChats) { chat in
                    chatView(chat: chat)
                        .padding(.bottom, Constants.defSpacing)
                        .listRowInsets(EdgeInsets())
                }
                .onDelete(perform: deleteChat)
            }
        }
        .navigationDestination(isPresented: $presentChat, destination: {
            ChatDetailView(showTabBar: $showTabBar, chat: chat, model: model)
                .navigationBarBackButtonHidden()
        })
        .listStyle(PlainListStyle())
        .refreshable {
            await model.getChats()
        }
    }
    
    func deleteChat(at offsets: IndexSet) {
        withAnimation {
            offsets.forEach { index in
                if index < model.chats?.count ?? 0 {
                    let chatId = model.chats?[index].id ?? 0
                    Task { @MainActor in
                        await model.deleteChat(chatId: chatId)
                    }
                    model.chats?.remove(at: index)
                }
            }
        }
    }
    
    var searchChatTextField: some View {
        SearchTextFieldView(onAppear: {
            filterIsOn = model.filtersNotActive()
        }, input: $input, buttonAction: {
            filterPresent = true
        }, filterIsOn: $filterIsOn,
        isChats: true)
    }
    
    func convertDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let timeString = dateFormatter.string(from: date)
        return timeString
    }
    
    func chatView(chat: Chat) -> some View {
        Button (action: {
            self.chat = chat
            presentChat = true
        }) {
            VStack(spacing: Constants.defSpacing) {
                HStack(spacing: Constants.smallStack) {
                    Image("person", bundle: .module)
                        .resizable()
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(alignment: .top) {
                            Text(model.getResponder(chat: chat).name)
                                .font(Fonts.mainBold)
                                .foregroundColor(.black)
                            Spacer()
                            Text(convertDate(date: (chat.messages.last?.date) ?? Date.now))
                                .foregroundColor(Color("grey", bundle: .module))
                                .font(Fonts.small)
                        }
                        HStack {
                            Text(chat.messages.last?.text ?? "")
                                .font(Fonts.small)
                                .foregroundColor(Color("grey", bundle: .module))
                                .lineLimit(1)
                            if(chat.messages.last?.isCurrentUser == true) {
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .frame(width: 10, height: 10)
                                    .padding(.trailing, 10)
                                    .foregroundColor(Color(.accent))
                            } else {
                                Spacer()
                                if countUnread(chat: chat) != 0 {
                                    Text("\(countUnread(chat: chat))")
                                        .font(Fonts.small)
                                        .foregroundColor(.white)
                                        .background {
                                            Circle()
                                                .foregroundColor(Color(.accent))
                                                .frame(width: 20)
                                        }
                                        .padding(.trailing, 10)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    
    func countUnread(chat: Chat) -> Int {
        var count = 0
        for message in chat.messages {
            if !(message.isRead ?? false) && !message.isCurrentUser {
                count += 1
            }
        }
        return count
    }
    
    var select: some View {
        HStack(spacing: Constants.defSpacing) {
            VStack {
                Text("Ваши чаты")
                    .font(Fonts.main)
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
                    .font(Fonts.main)
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
