import SwiftUI
import Types
import UIComponents

public struct AddMaterialView<Model: MaterialsViewModel>: View {

    public init(model: Model, showTabBar: Binding<Bool>) {
        self._model = ObservedObject(wrappedValue: model)
        self._showTabBar = showTabBar
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Constants.defSpacing) {
            header
            tipForm
            Spacer()
            saveButton
        }
        .onAppear {
            withAnimation {
                showTabBar.toggle()
            }
        }
        .onDisappear {
            withAnimation {
                showTabBar.toggle()
            }
        }
        .padding(.horizontal, Constants.horizontal)
        .navigationBarBackButtonHidden()
        .overlay {
            if model.isAddMaterialLoading {
                LoadingScreen(placeholder: "Добавляем материал...")
            }
            if model.isError {
                ErrorView(retryAction: retryAction)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading) {
            BackButton()
            heading
        }
    }

    private var heading: some View {
        Text("Добавление совета")
            .font(Fonts.heading)
            .foregroundStyle(.black)
            .multilineTextAlignment(.leading)
    }

    private var tipForm: some View {
        VStack(alignment: .leading, spacing: Constants.defSpacing) {
            TextFieldView(model: .customOneLiner(placeholder: "имя, фамилия автора", canClearAll: true), input: $authorInput)
            professionPicker
            companyPicker
            TextFieldView(model: .custom(placeholder: "текст совета", canClearAll: true), input: $tipText)
        }
    }

    private var saveButton: some View {
        MainButton(
            action: {
                Task { @MainActor in
                    guard !authorInput.isEmpty, !tipText.isEmpty else { return }
                    if await model.addTip(company: company, author: authorInput, text: tipText, role: profession) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            },
            label: "Добавить"
        )
    }

    private var companyPicker: some View {
        HStack {
            Text("Компания")
                .foregroundColor(Color(.lightGray))
            Spacer()

            Menu {
                ForEach(companies, id: \.self) { company in
                    Button {
                        self.company = company
                    } label: {
                        Text(company.rawValue)
                    }
                }
            } label: {
                HStack {
                    Text(company.rawValue)
                        .foregroundStyle(.black)
                    Image(systemName: "chevron.down")
                        .foregroundStyle(.black)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, Constants.elementPadding)
        .padding(.vertical, Constants.elementPadding)
        .background {
            RoundedRectangle(cornerRadius: Constants.corner)
                .stroke(Color(.lightGray), lineWidth: Constants.strokeWidth)
        }
    }

    private var professionPicker: some View {
        HStack {
            Text("Профессия")
                .foregroundColor(Color(.lightGray))
            Spacer()

            Menu {
                ForEach(professions, id: \.self) { profession in
                    Button {
                        self.profession = profession
                    } label: {
                        Text(self.profession.rawValue)
                    }
                }
            } label: {
                HStack {
                    Text(profession.rawValue)
                        .foregroundStyle(.black)
                    Image(systemName: "chevron.down")
                        .foregroundStyle(.black)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, Constants.elementPadding)
        .padding(.vertical, Constants.elementPadding)
        .background {
            RoundedRectangle(cornerRadius: Constants.corner)
                .stroke(Color(.lightGray), lineWidth: Constants.strokeWidth)
        }
    }

    private func retryAction() {
        Task { @MainActor in
            guard !authorInput.isEmpty, !tipText.isEmpty else { return }
            if await model.addTip(company: company, author: authorInput, text: tipText, role: profession) {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }

    @ObservedObject private var model: Model
    @State private var authorInput: String = ""
    @State private var roleInput: String = ""
    @State private var tipText: String = ""
    @Binding private var showTabBar: Bool

    @State private var company: Company = .tinkoff
    private let companies: [Company] = [.tinkoff, .yandex]

    @State private var profession: Professions = .project
    private let professions: [Professions] = [.project, .product, .analyst]

    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

}
