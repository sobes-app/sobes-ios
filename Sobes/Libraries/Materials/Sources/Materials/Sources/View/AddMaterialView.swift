import SwiftUI
import Types
import UIComponents

public struct AddMaterialView<Model: MaterialsViewModel>: View {

    public init(model: Model, type: Types.MaterialWithoutModel) {
        self._model = ObservedObject(wrappedValue: model)
        self.materialType = type
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Constants.defSpacing) {
            header
            switch materialType {
            case .tip:
                tipForm
            case .article:
                articleForm
            }
            Spacer()
            saveButton
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
        Text(materialType == .tip ? "Добавление совета" : "Добавление статьи")
            .font(Fonts.heading)
            .foregroundStyle(.black)
            .multilineTextAlignment(.leading)
    }

    private var tipForm: some View {
        VStack(alignment: .leading, spacing: Constants.defSpacing) {
            TextFieldView(model: .customOneLiner(placeholder: "имя, фамилия автора", canClearAll: true), input: $authorInput)
            TextFieldView(model: .customOneLiner(placeholder: "должность", canClearAll: true), input: $roleInput)
            companyPicker
            TextFieldView(model: .custom(placeholder: "текст совета", canClearAll: true), input: $tipText)
        }
    }

    private var articleForm: some View {
        VStack(alignment: .leading, spacing: Constants.defSpacing) {
            TextFieldView(model: .customOneLiner(placeholder: "ссылка на статью", canClearAll: true), input: $linkText)
        }
    }

    private var saveButton: some View {
        MainButton(
            action: {
                Task { @MainActor in
                    switch materialType {
                    case .article:
                        guard !linkText.isEmpty else { return }
                        if await model.addArticle(link: linkText) {
                            presentationMode.wrappedValue.dismiss()
                        }

                    case .tip:
                        guard !authorInput.isEmpty, !tipText.isEmpty else { return }
                        if await model.addTip(company: company, author: authorInput, text: tipText, role: roleInput) {
                            presentationMode.wrappedValue.dismiss()
                        }
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

    private func retryAction() {
        Task { @MainActor in
            switch materialType {
            case .tip:
                guard !authorInput.isEmpty, !tipText.isEmpty else { return }
                if await model.addTip(company: company, author: authorInput, text: tipText, role: roleInput) {
                    presentationMode.wrappedValue.dismiss()
                }
            case .article:
                guard !linkText.isEmpty else { return }
                if await model.addArticle(link: linkText) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }

    @ObservedObject private var model: Model
    @State private var authorInput: String = ""
    @State private var roleInput: String = ""
    @State private var tipText: String = ""
    @State private var linkText: String = ""
    private let materialType: MaterialWithoutModel

    @State private var company: Company = .tinkoff
    private let companies: [Company] = [.tinkoff, .yandex]

    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

}
