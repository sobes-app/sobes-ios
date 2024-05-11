import Foundation

public struct TipResponse: Decodable {
    public let id: Int
    public let profession: String
    public let company: String
    public let name: String
    public let level: String
    public let text: String
}

public struct ArticleResponse: Decodable {
    public let id: Int
    public let profession: String
    public let title: String
    public let author: String
    public let content: String
    public let link: String
}

public final class MaterialsClient {

    public init() {
        self.netLayer = NetworkLayer()
    }

    public func getTips() async -> Result<[TipResponse], ClientError> {
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(
                method: "GET",
                urlPattern: "/user/advise",
                body: EmptyRequest()
            ) { result in
                continuation.resume(returning: result)
            }
        }
    }

    public func getArticles() async -> Result<[ArticleResponse], ClientError> {
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(
                method: "GET",
                urlPattern: "/user/article",
                body: EmptyRequest()
            ) { result in
                continuation.resume(returning: result)
            }
        }
    }

    public func getArticle(by id: Int) async -> Result<ArticleResponse, ClientError> {
        await withCheckedContinuation { continuation in
            self.netLayer.makeRequest(
                method: "GET",
                urlPattern: "/user/article/\(id)",
                body: EmptyRequest()
            ) { result in
                continuation.resume(returning: result)
            }
        }
    }

    private let netLayer: NetworkLayer
}
