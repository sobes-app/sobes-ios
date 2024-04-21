import SwiftUI

public struct Filter: Identifiable {

    public let id: Int
    public let name: String
    public var isActive: Bool

    public init(id: Int, name: String, isActive: Bool = false) {
        self.id = id
        self.name = name
        self.isActive = isActive
    }

}
