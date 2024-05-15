import SwiftUI
import UIComponents
import PhotosUI

enum FeedbackType: CaseIterable {
    case bug
    case feature
    case other
}

public struct FeedbackView<Model: ProfileViewModel>: View {
    @State var feedbackType: FeedbackType = .bug
    
    public init(model: Model, showTabBar: Binding<Bool>) {
        self._model = ObservedObject(wrappedValue: model)
        self._showTabBar = showTabBar
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            BackButton()
            VStack(alignment: .leading, spacing: Constants.defSpacing) {
                Text("Обратная связь")
                    .font(Fonts.heading)
                    .foregroundColor(.black)
                picker
                if model.isLoading {
                    LoadingScreen(placeholder: "Отправляю")
                } else if model.isError {
                    ErrorView(retryAction: {
                        Task { @MainActor in
                            await model.sendFeedback(content: text)
                        }
                    })
                } else {
                    switch selected {
                    case .bug:
                        bugView
                    case .feature:
                        featureView
                    case .other:
                        otherView
                    }
                }
            }
            .padding(.top, Constants.topPadding)
        }
        .padding(.horizontal, Constants.horizontal)
        .padding(.bottom, Constants.bottom)
        .onAppear {
            withAnimation {
                showTabBar = false
            }
        }
        .onDisappear{
            withAnimation {
                showTabBar = true
            }
        }
    }
    
    var picker: some View {
        Picker("Picker Name", selection: $selected, content: {
            Text("Баг").tag(FeedbackType.bug)
            Text("Улучшение").tag(FeedbackType.feature)
            Text("Другое").tag(FeedbackType.other)
        })
        .pickerStyle(.segmented)
    }
    
    var bugView: some View {
        VStack(alignment: .leading, spacing: Constants.defSpacing) {
            Text("Здесь вы можете написать о возникшей ошибке. Будет круто, если вы сможете описать последовательность действий до возникновения ошибки и/или прикрепите скриншоты")
                .font(Fonts.small)
                .foregroundColor(Color("grey", bundle: .module))
            textField
            Spacer()
            MainButton(action: {
                Task { @MainActor in
                    if await model.sendFeedback(content: text) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }, label: "Отправить")
        }
    }
    
    var featureView: some View {
        VStack(alignment: .leading, spacing: Constants.defSpacing) {
            Text("Здесь вы можете написать предложение по улучшению функционала или интерфейса приложения")
                .font(Fonts.small)
                .foregroundColor(Color("grey", bundle: .module))
            textField
            Spacer()
            MainButton(action: {}, label: "Отправить")
        }
    }
    
    var otherView: some View {
        VStack(alignment: .leading, spacing: Constants.defSpacing) {
            Text("Здесь вы можете написать всё что угодно :)")
                .font(Fonts.small)
                .foregroundColor(Color("grey", bundle: .module))
            textField
            Spacer()
            MainButton(action: {}, label: "Отправить")
        }
    }
    
    var textField: some View {
        TextField("Оставь отзыв", text: $text, axis: .vertical)
            .lineLimit(5...10)
            .font(Fonts.small)
            .padding(Constants.elementPadding)
            .background {
                RoundedRectangle(cornerRadius: Constants.corner)
                    .foregroundColor(Color(.light))
            }
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var selected: FeedbackType = .bug
    @State var text: String = ""
    @ObservedObject private var model: Model
    @Binding private var showTabBar: Bool
}
