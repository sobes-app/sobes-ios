import Foundation

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
}
