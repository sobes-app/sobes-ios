import SwiftUI
import Types
import Toolbox
import Providers

@MainActor
public protocol MaterialsViewModel: ObservableObject {
    var materials: [Types.Material] { get }
    var filters: [Types.Filter] { get }
    var materialsFilters: [Types.Filter] { get }
    func onViewAppear() async
    func onFilterTapped(id: Int) async
    func onMaterialsFilterTapped(id: Int) async
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

}

extension Int {

    fileprivate var isTipsFilter: Bool {
        return self == 0
    }

}
