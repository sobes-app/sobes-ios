import SwiftUI

public struct Profile: Identifiable {

    public let id: Int
    public let name: String
    public var desired: [String]
    public var companies: [String]
    public var experience: String

    public init(id: Int, name: String, desired: [String], companies: [String], experience: String) {
        self.id = id
        self.name = name
        self.desired = desired
        self.companies = companies
        self.experience = experience
    }

}
