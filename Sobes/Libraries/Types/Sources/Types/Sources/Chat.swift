import SwiftUI
import NetworkLayer

public struct Chat: Identifiable, Equatable {

    public let id: Int
    public let firstResponderId: Int
    public let secondResponderId: Int
    public var messages: [Message]

    public init(id: Int, firstResponder: Int, secordResponder: Int, messages: [Message]) {
        self.id = id
        self.firstResponderId = firstResponder
        self.secondResponderId = secordResponder
        self.messages = messages
    }
    
    public init(chat: CreateChatResponse) {
        self.id = chat.id 
        self.firstResponderId = chat.participantone.id
        self.secondResponderId = chat.participanttwo.id
        self.messages = []
    }
}
