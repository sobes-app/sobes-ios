import Foundation
import Alamofire

public struct NewsResponse: Decodable {
    public let status: String
    public let totalResults: Int
    public let articles: [NewsArticle]
}

public struct NewsArticle: Decodable {
    public let source: Source
    public let author: String?
    public let title: String
    public let description: String?
    public let url: String
    public let urlToImage: String?
    public let publishedAt: String
}

public struct Source: Decodable {
    public let id: String?
    public let name: String
}

@available(macOS 10.15, iOS 13.0, *)
public final class NewsAPIClient {

    public init() {}

    public func fetchArticles(query: String) async -> Result<[NewsArticle], Error> {
        await withCheckedContinuation { continuation in
            let parameters: [String: Any] = [
                "q": query,
                "domains": "habr.com",
                "language": "ru",
                "apiKey": apiKey
            ]

            AF.request(baseURL, parameters: parameters).responseDecodable(of: NewsResponse.self) { response in
                switch response.result {
                case .success(let newsResponse):
                    print(newsResponse.totalResults)
                    continuation.resume(returning: .success(newsResponse.articles))
                case .failure(let error):
                    continuation.resume(returning: .failure(error))
                }
            }
        }
    }

    private let apiKey = "27cf3cd2bf704dc6830842d55a840b5f"
    private let baseURL = "https://newsapi.org/v2/everything"

}
