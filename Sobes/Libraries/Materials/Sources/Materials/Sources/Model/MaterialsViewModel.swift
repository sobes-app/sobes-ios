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
    var appMode: ApplicationMode { get }
    var isLoading: Bool { get }
    var isAddMaterialLoading: Bool { get }
    var isError: Bool { get }
    func onViewAppear() async
    func onFilterTapped(id: Int) async
    func updateMaterials() async
    func onMaterialsFilterTapped(id: Int) async
    func getParsedArticle(article: Types.Article) async -> ParsedArticle?

    // admin mode functions
    func addTip(company: Company, author: String, text: String, role: Professions) async -> Bool
}

@MainActor
public final class MaterialsViewModelImpl: MaterialsViewModel {

    @Published public var materials: [Types.Material] = []
    @Published public var filters: [Types.Filter] = []
    @Published public var materialsFilters: [Types.Filter] = []
    @Published public var appMode: ApplicationMode = .user
    @Published public var isLoading: Bool = false
    @Published public var isAddMaterialLoading: Bool = false
    @Published public var isError: Bool = false

    public init(materialsProvider: MaterialsProvider, profileProvider: ProfileProvider) {
        self.materialsProvider = materialsProvider
        self.profileProvider = profileProvider
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

        appMode = await profileProvider.getCurrentUserMode()
    }

    public func onFilterTapped(id: Int) async {
        filters[id].isActive.toggle()
        await updateMaterials()
    }

    public func updateMaterials() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Task { @MainActor [weak self] in
                guard let self else { return }
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

    public func getParsedArticle(article: Types.Article) async -> ParsedArticle? {
        return await fetchArticle(from: article.url)
    }

    public func addTip(company: Company, author: String, text: String, role: Professions) async -> Bool {
        isAddMaterialLoading = true
        let result = await materialsProvider.addTip(company: company.rawValue, author: author, text: text, role: role.rawValue)
        switch result {
        case .success:
            isAddMaterialLoading = false
            return true
        case .failure:
            isAddMaterialLoading = false
            isError = true
            return false
        }
    }

    private let materialsProvider: MaterialsProvider
    private let profileProvider: ProfileProvider

    private func filtersNotActive() -> Bool {
        return !filters.contains { $0.isActive }
    }

    private func getMaterialsActiveFilter() -> Int {
        return materialsFilters.firstIndex(where: { $0.isActive }) ?? 0
    }

    private func getTips() async -> [Types.Material] {
        isError = false
        isLoading = true

        let result = await materialsProvider.getTips()
        switch result {
        case .success(let tips):
            isLoading = false
            return tips
        case .failure(let error):
            isLoading = false
            switch error {
            case .empty:
                return []
            case .error:
                isError = true
            }
        }
        return []
    }

    private func getArticles() async -> [Types.Material] {
        isError = false
        isLoading = true

        let result = await materialsProvider.fetchArticles()
        switch result {
        case .success(let articles):
            isLoading = false
            return articles
        case .failure(let error):
            isLoading = false
            switch error {
            case .empty:
                return []
            case .error:
                isError = true
            }
        }
        return []
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

            let paragraphs = try doc.select("p").array().dropLast(5).map { try $0.text() }
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
