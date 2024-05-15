import Foundation


public struct CreateChatResponse: Decodable {
    public let id: Int
    public let participantone: Participant
    public let participanttwo: Participant
}

public struct Participant: Decodable {
    public let id: Int
    public let username: String
    public let email: String
}

public struct MessagesResponse: Decodable {
    public let messageId: Int
    public let sender: Participant
    public let responder: Participant
    public let text: String
    public let date: String
    public let isRead: Bool
    public let chatId: Int
}

public struct FeedbackResponse: Decodable, Identifiable {
    public let id: Int
    public let user: Participant
    public let content: String
    public let createdAt: String
}

public struct FeedbackRequest: Encodable {
    public let content: String
}

public struct ReadResponse: Decodable {
    public let id: Int
}

@available(macOS 10.15, iOS 13.0, *)
public final class ChatsClient {
    let netLayer: NetworkLayer
    
    public init() {
        self.netLayer = NetworkLayer()
    }
    
    public func getProfiles() async -> Result<[ProfileResponse], ClientError> {
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(method: "GET",
                                      urlPattern: "/user/profiles",
                                      body: EmptyRequest()) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    public func createChat(userId: Int) async -> Result<CreateChatResponse, ClientError> {
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(method: "POST",
                                      urlPattern: "/chat/\(userId)",
                                      body: EmptyRequest()) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    public func getChats() async -> Result<[CreateChatResponse], ClientError> {
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(method: "GET",
                                      urlPattern: "/chat",
                                      body: EmptyRequest()) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    public func getMessages(chatId: Int) async -> Result<[MessagesResponse], ClientError> {
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(method: "GET",
                                      urlPattern: "/chat/\(chatId)/messages",
                                      body: EmptyRequest()) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    public func deleteChat(chatId: Int) async -> Result<[String: String], ClientError> {
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(method: "DELETE",
                                      urlPattern: "/chat/\(chatId)",
                                      body: EmptyRequest()) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    public func readMessages(messages: [Int]) async -> Result<[ReadResponse], ClientError> {
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(method: "POST",
                                      urlPattern: "/chat/read",
                                      body: messages) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    public func getFeedbacks() async -> Result<[FeedbackResponse], ClientError> {
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(method: "GET",
                                      urlPattern: "/feedback",
                                      body: EmptyRequest()) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
