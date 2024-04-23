import SwiftUI

public struct Chat: Identifiable {

    public let id: Int
    public let firstResponder: Profile
    public let secondResponder: Profile
    public var messages: [Message]

    public init(id: Int, firstResponder: Profile, secordResponder: Profile, messages: [Message]) {
        self.id = id
        self.firstResponder = firstResponder
        self.secondResponder = secordResponder
        self.messages = messages
    }
}
