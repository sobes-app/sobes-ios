import SwiftUI
import UIComponents
import Types
import Combine
import SwiftUIGIF

struct ChatDetailView<Model: ChatViewModel>: View {
    @ObservedObject private var model: Model
    
    @State private var input: String = ""
    @State private var inputState: TextFieldView.InputState = .correct
    @State private var isPopoverPresented: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding private var showTabBar: Bool
    private let chat: Chat
    
    public init(showTabBar: Binding<Bool>, chat: Chat, model: Model) {
        self._showTabBar = showTabBar
        self.chat = chat
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
            ScrollViewReader { proxy in
                messages()
                    .onReceive(Just(chat.messages)) { _ in
                        withAnimation {
                            proxy.scrollTo("bottom")
                        }
                    }
                
                TextFieldView(model: .chat, input: $input, inputState: $inputState, onSend: {
                    model.addMessageToChat(chatId: chat.id, text: input)
                    input = ""
                })
                .onTapGesture {
                    proxy.scrollTo("bottom")
                }
                .padding(.top, Constants.defSpacing)
            }
        }
        .navigationBarBackButtonHidden()
        .padding(.horizontal, Constants.horizontal)
        .padding(.bottom, Constants.bottom)
        .onAppear {
            showTabBar = false
        }
    }
    
    func messages() -> some View {
        ScrollView {
            ForEach(chat.messages) { message in
                VStack(spacing: 5) {
                    MessageBubble(message: message, isCurrentUser: message.isCurrentUser)
                        .id(message.id)
                }
            }
            Spacer()
                .frame(height: 0)
                .id("bottom")
        }
        .scrollIndicators(.hidden)
    }
    
    var responderName: some View {
        Text(model.getResponder(chat: chat).name)
            .font(Fonts.mainBold)
            .foregroundColor(.black)
    }
    
    var description: some View {
        VStack(alignment: .leading) {
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
    
    var back: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
            showTabBar = true
        }) {
            Image(systemName: "chevron.backward")
                .foregroundColor(.black)
                .frame(width: 10, height: 10, alignment: .leading)
        }
    }
    
    var info: some View {
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
}
