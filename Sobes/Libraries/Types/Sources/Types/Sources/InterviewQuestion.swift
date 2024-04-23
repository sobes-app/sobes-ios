import Foundation

public struct InterviewQuestion: Identifiable {

    public let id: Int
    public let text: String
    public let result: Double?

    public init(id: Int, text: String, result: Double? = nil) {
        self.id = id
        self.text = text
        self.result = result
    }
    
}
