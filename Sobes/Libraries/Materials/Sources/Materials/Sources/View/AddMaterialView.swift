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
                EmptyView()
            }
            Spacer()
        }
        .padding(.horizontal, Constants.horizontal)
        .navigationBarBackButtonHidden()
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
        VStack(alignment: .leading, spacing: 16) {
            TextFieldView(model: .custom(placeholder: "название"), input: $titleInput)
            TextFieldView(model: .custom(placeholder: "автор"), input: $authorInput)
        }
    }

    @ObservedObject private var model: Model
    @State private var titleInput: String = ""
    @State private var authorInput: String = ""
    private let materialType: Types.MaterialWithoutModel

}
