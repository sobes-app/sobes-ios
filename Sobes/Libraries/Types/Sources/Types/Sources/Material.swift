import Foundation

public enum Material: Hashable {

    case tip(model: Tip)
    case article(model: Article)

}

public enum MaterialWithoutModel {

    case tip
    case article

}
