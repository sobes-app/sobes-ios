import Foundation

public struct TipResponse: Decodable {
    public var id: Int
    public var profession: String
    public var company: String
    public var name: String
    public var level: String
    public var text: String
}

public struct ArticleResponse: Decodable {
    public var id: Int
    public var profession: String
    public var title: String
    public var author: String
    public var content: String
    public var link: String
}

public final class MaterialsClient {

    public init(token: String?) {
        self.netLayer = NetworkLayer(token: token)
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
