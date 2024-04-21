import Foundation

public enum Material: Hashable {

    case tip(model: Tip)
    case article(model: Article)

    public static func getCompanyName(of material: Material) -> String {
        switch material {
        case .tip(let model):
            return model.companyName
        case .article(let model):
            return model.companyName
        }
    }
    
}
