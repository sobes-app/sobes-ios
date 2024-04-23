import SwiftUI
import UIComponents
import Types
import Combine


struct ChatDetailView<Model: ChatViewModel>: View {
    @ObservedObject private var model: Model
    
    @State private var input: String = ""
    @State private var inputState: TextFieldView.InputState = .correct
    @State var scale = 1.0
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
                responderName
            }
            description
                .frame(maxWidth: .infinity, alignment: .leading)
            Rectangle()
                .foregroundColor(Color(.light))
                .frame(height: 1)
            ScrollViewReader { proxy in
                messages
                    .onChange(of: chat.messages) {
                        withAnimation {
                            proxy.scrollTo("bottom")
                        }
                    }
                TextFieldView(model: .chat, input: $input, inputState: $inputState, onSend: {
                    model.addMessageToChat(chatId: chat.id, text: input)
                    input = ""
                })
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
    
    var messages: some View {
        ScrollView {
            ForEach(chat.messages) { message in
                if message.author == model.profileId {
                    MessageBubble(message: message, type: .selfMessage)
                        .id(message.id)
                        .padding(.leading, 30)
                } else {
                    MessageBubble(message: message, type: .responder)
                        .id(message.id)
                        .padding(.trailing, 30)
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
            Text("Желаемые должности: \(Profile.createStringOfProfessions(of: model.getResponder(chat: chat)).joined(separator: ", "))")
                .font(Fonts.small)
                .foregroundColor(.black)
            Text("Желаемая позиция: \(model.getResponder(chat: chat).level.rawValue)")
                .font(Fonts.small)
                .foregroundColor(.black)
            Text("Хочет работать в: \(Profile.createStringOfCompanies(of: model.getResponder(chat: chat)).joined(separator: ", "))")
                .font(Fonts.small)
                .foregroundColor(.black)
        }
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
}
