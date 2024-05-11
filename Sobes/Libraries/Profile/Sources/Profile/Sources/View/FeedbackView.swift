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
                switch selected {
                case .bug:
                    bugView
                case .feature:
                    featureView
                case .other:
                    otherView
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
            photoPickerButton
            if imagesSelection != [] {
                imagesScroll
            }
            textField
            Spacer()
            MainButton(action: {}, label: "Отправить")
        }
        .onChange(of: itemsSelection, perform: { value in
            Task {
                imagesSelection.removeAll()
                for item in itemsSelection {
                    if let image = try? await item.loadTransferable(type: Image.self) {
                        imagesSelection.append(image)
                    }
                }
            }
        })
        .photosPicker(isPresented: $presentPhotoPicker, selection: $itemsSelection)
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
    
    var photoPickerButton: some View {
        Button(action: { presentPhotoPicker = true }, label: {
            HStack {
                Text("добавить фото")
                    .foregroundColor(Color(.accent))
                    .font(Fonts.small)
                Image(systemName: "photo")
                    .accentColor(Color(.accent))
            }
        })
    }
    
    var imagesScroll: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(0..<imagesSelection.count, id: \.self) { index in
                    ZStack {
                        imagesSelection[index]
                            .resizable()
                            .frame(width: 70, height: 70)
                            .cornerRadius(Constants.corner)
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .onTapGesture {
                                imagesSelection.remove(at: index)
                            }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
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
    
    @State private var selected: FeedbackType = .bug
    
    @State var imagesSelection: [Image] = []
    @State var itemsSelection: [PhotosPickerItem] = []
    
    @State var presentPhotoPicker: Bool = false
    @State var text: String = ""
    @ObservedObject private var model: Model
    @Binding private var showTabBar: Bool
}
