import SwiftUI
import Types
import Toolbox
import Providers
import Alamofire
import SwiftSoup

@MainActor
public protocol MaterialsViewModel: ObservableObject {
    var materials: [Types.Material] { get }
    var filters: [Types.Filter] { get }
    var materialsFilters: [Types.Filter] { get }
    func onViewAppear() async
    func onFilterTapped(id: Int) async
    func onMaterialsFilterTapped(id: Int) async
    func getParsedArticle(id: Int) async -> ParsedArticle?
}

@MainActor
public final class MaterialsViewModelImpl: MaterialsViewModel {

    @Published public var materials: [Types.Material] = []
    @Published public var filters: [Types.Filter] = []
    @Published public var materialsFilters: [Types.Filter] = []

    public init(materialsProvider: MaterialsProvider) {
        self.materialsProvider = materialsProvider
    }

    public func onViewAppear() async {
        materials = await getTips()
        filters = [
            Filter(id: 0, name: "Тинькофф"),
            Filter(id: 1, name: "Яндекс")
        ]
        materialsFilters = [
            Filter(id: 0, name: "Советы", isActive: true),
            Filter(id: 1, name: "Статьи")
        ]
    }

    private let materialsProvider: MaterialsProvider

    public func onFilterTapped(id: Int) async {
        filters[id].isActive.toggle()
        if filtersNotActive() {
            if materialsFilters.isTipsFilterActive {
                materials = await getTips()
            } else {
                materials = await getArticles()
            }
        } else {
            var filteredMaterials: [Types.Material] = []
            for filter in filters {
                if filter.isActive {
                    if materialsFilters.isTipsFilterActive {
                        filteredMaterials.append(contentsOf: await getTips().filter { material in
                            switch material {
                            case .tip(let model):
                                return model.company.rawValue.contains(filter.name)
                            case .article:
                                return false
                            }
                        })
                    } else {
                        filteredMaterials = await getArticles()
                    }
                }
            }
            materials = filteredMaterials
        }
    }

    public func onMaterialsFilterTapped(id: Int) async {
        for i in 0...materialsFilters.count - 1 {
            materialsFilters[i].isActive = false
        }
        materialsFilters[id].isActive.toggle()
        if id.isTipsFilter {
            materials = await getTips()
        } else {
            materials = await getArticles()
        }
    }

    public func getParsedArticle(id: Int) async -> ParsedArticle? {
        let material = await getArticles()[id]
        guard case .article(let article) = material else { return nil }
        return await fetchArticle(from: article.url)
    }

    private func filtersNotActive() -> Bool {
        return !filters.contains { $0.isActive }
    }

    private func getMaterialsActiveFilter() -> Int {
        return materialsFilters.firstIndex(where: { $0.isActive }) ?? 0
    }

    private func getTips() async -> [Types.Material] {
        return await materialsProvider.getTips()
    }

    private func getArticles() async -> [Types.Material] {
        return await materialsProvider.getArticles()
	}

    private func fetchArticle(from url: String) async -> ParsedArticle? {
        await withCheckedContinuation { continuation in
            AF.request(url).responseString { [weak self] response in
                switch response.result {
                case .success(let html):
                    if let article = self?.parseArticle(html: html, url: url) {
                        continuation.resume(with: .success(article))
                    }
                case .failure(let error):
                    print("Error while fetching the page: \(error.localizedDescription)")
                    continuation.resume(with: .success(nil))
                }
            }
        }
    }

    private func parseArticle(html: String, url: String) -> ParsedArticle? {
        do {
            let doc: Document = try SwiftSoup.parse(html)
            let heading = try doc.select("h1").first()?.text()

//            let h2 = try doc.select("h2").array().map { try $0.text() }
//            let h3 = try doc.select("h3").array().map { try $0.text() }

            let paragraphs = try doc.select("p").array().map { try $0.text() }
            let bodyText = paragraphs.joined(separator: "\n\n")

            let authorName = try doc.select(".tm-user-info__username").first()?.text()
            let datePublished = try doc.select(".tm-article-datetime-published").first()?.text()

            let keywords = try doc.select("meta[name=keywords]").first()?.attr("content").split(separator: ", ").map { String($0) }

            return ParsedArticle(
                id: 0,
                source: URL(string: url)?.host(),
                tags: keywords ?? [],
                logo: URL(string: url)?.host(),
                author: authorName,
                heading: heading,
                datePublished: datePublished,
                bodyText: bodyText,
                url: url
            )
        } catch Exception.Error(let type, let message) {
            print("Error parsing HTML (\(type)): \(message)")
        } catch {
            print("An unknown error occurred while parsing HTML.")
        }

        return nil
    }

    private func downloadImage(from url: URL) -> Image? {
        var userPic: Image?
        AF.download(url).responseData { response in
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    userPic = Image(uiImage: image)
                }
            case .failure(let error):
                print("Error in downloading image: \(error.localizedDescription)")
            }
        }

        return userPic
    }

}

extension Int {

    fileprivate var isTipsFilter: Bool {
        return self == 0
    }

}
