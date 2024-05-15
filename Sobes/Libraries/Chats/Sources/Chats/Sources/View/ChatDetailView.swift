import SwiftUI
import UIComponents
import Types
import Combine
import SwiftUIGIF

struct ChatDetailView<Model: ChatViewModel>: View {
    @ObservedObject private var model: Model
    
    @State private var input: String = ""
    @State private var isPopoverPresented: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding private var showTabBar: Bool
    @State var isMessagesEmpty: Bool = true
    private let chat: Chat
    @State var isLoading: Bool = false
    
    public init(showTabBar: Binding<Bool>, chat: Chat, model: Model) {
        self._showTabBar = showTabBar
        self.chat = chat
        if !chat.messages.isEmpty {
            isMessagesEmpty = false
        }
        self._model = ObservedObject(wrappedValue: model)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: Constants.defSpacing) {
            HStack(spacing: Constants.defSpacing) {
                back
                Spacer()
                responderName
                Spacer()
                info
            }
            Rectangle()
                .foregroundColor(Color(.light))
                .frame(height: 1)
            if isLoading {
                LoadingScreen(placeholder: "загружаю сообщения...")
            } else {
                ScrollViewReader { proxy in
                    messages()
                        .onReceive(Just(chat.messages)) { _ in
                            withAnimation {
                                proxy.scrollTo("bottom")
                            }
                        }
                    
                    TextFieldView(model: .chat, input: $input, onSend: {
                        model.sendChatMessage(chatId: chat.id, senderId: model.getCurrentUserId(), text: input)
                        isMessagesEmpty = false
                        input = ""
                    })
                    .onTapGesture {
                        proxy.scrollTo("bottom")
                    }
                    .padding(.top, Constants.defSpacing)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .padding(.horizontal, Constants.horizontal)
        .padding(.bottom, Constants.bottom)
        .task {
            isLoading = true
            _ = await model.fetchMessages(chatId: chat.id)
            await model.readMessages(chat: chat)
            isLoading = false
        }
        .onAppear {
            showTabBar = false
        }
    }
    
    var responderName: some View {
        Text(model.getResponder(chat: chat).name)
            .font(Fonts.mainBold)
            .foregroundColor(.black)
    }
    
    private var description: some View {
        VStack(alignment: .leading) {
            if model.getResponder(chat: chat).professions.isEmpty {
                Text("Пользователь еще не заполнил информацию о себе")
                    .font(Fonts.small)
                    .foregroundColor(.black)
            }
            if !model.getResponder(chat: chat).professions.isEmpty {
                Text("#\(Profile.createStringOfProfessions(of: model.getResponder(chat: chat)).joined(separator: ", "))")
                    .font(Fonts.small)
                    .foregroundColor(.black)
            }
            if model.getResponder(chat: chat).level != .no {
                Text("#\(model.getResponder(chat: chat).level.rawValue)")
                    .font(Fonts.small)
                    .foregroundColor(.black)
            }
            if !model.getResponder(chat: chat).companies.isEmpty {
                Text("#\(Profile.createStringOfCompanies(of: model.getResponder(chat: chat)).joined(separator: " #"))")
                    .font(Fonts.small)
                    .foregroundColor(.black)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var back: some View {
        Button(action: {
            Task { @MainActor in
                if let chatToRead = model.chats?.first(where: { chat in
                    chat.id == self.chat.id
                }) {
                    await model.readMessages(chat: chatToRead)
                }
                await model.getChats()
            }
            presentationMode.wrappedValue.dismiss()
            showTabBar = true
            if isMessagesEmpty {
                Task { @MainActor in
                    await model.deleteChat(chatId: chat.id)
                }
            }
        }) {
            Image(systemName: "chevron.backward")
                .foregroundColor(.black)
                .frame(width: 10, height: 10, alignment: .leading)
        }
    }
    
    private var info: some View {
        Button(action: {
            isPopoverPresented = true
        }) {
            Image(systemName: "info")
                .foregroundColor(.black)
                .frame(width: 10, height: 10, alignment: .center)
        }
        .popover(isPresented: $isPopoverPresented) {
            description
                .presentationCompactAdaptation(.popover)
                .padding()
        }
    }
    
    func messages() -> some View {
        ScrollView {
            ForEach(model.messages, id:\.self) { message in
                VStack(spacing: 5) {
                    MessageBubble(message: message, isCurrentUser: message.isCurrentUser)
                }
            }
            Spacer()
                .frame(height: 0)
                .id("bottom")
        }
        .scrollIndicators(.hidden)
    }

}
