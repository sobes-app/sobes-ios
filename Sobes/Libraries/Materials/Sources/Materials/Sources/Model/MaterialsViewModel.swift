import SwiftUI
import Types
import Toolbox
import Providers

@MainActor
public protocol MaterialsViewModel: ObservableObject {
    var materials: [Types.Material] { get }
    var filters: [Types.Filter] { get }
    var materialsFilters: [Types.Filter] { get }
    func onViewAppear()
    func onFilterTapped(id: Int)
    func onMaterialsFilterTapped(id: Int)
}

@MainActor
public final class MaterialsViewModelImpl: MaterialsViewModel {

    @Published public var materials: [Types.Material] = []
    @Published public var filters: [Types.Filter] = []
    @Published public var materialsFilters: [Types.Filter] = []

    public init(materialsProvider: MaterialsProvider) {
        self.materialsProvider = materialsProvider
    }

    public func onViewAppear() {
        materials = getTips()
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

    public func onFilterTapped(id: Int) {
        filters[id].isActive.toggle()
        if filtersNotActive() {
            if materialsFilters.isTipsFilterActive {
                materials = getTips()
            } else {
                materials = getArticles()
            }
        } else {
            var filteredMaterials: [Types.Material] = []
            for filter in filters {
                if filter.isActive {
                    if materialsFilters.isTipsFilterActive {
                        filteredMaterials.append(contentsOf: getTips().filter { material in
                            switch material {
                            case .tip(let model):
                                return model.company.rawValue.contains(filter.name)
                            case .article:
                                return false
                            }
                        })
                    } else {
                        filteredMaterials = getArticles()
                    }
                }
            }
            materials = filteredMaterials
        }
    }

    public func onMaterialsFilterTapped(id: Int) {
        for i in 0...materialsFilters.count - 1 {
            materialsFilters[i].isActive = false
        }
        materialsFilters[id].isActive.toggle()
        if id.isTipsFilter {
            materials = getTips()
        } else {
            materials = getArticles()
        }
    }

    private func filtersNotActive() -> Bool {
        return !filters.contains { $0.isActive }
    }

    private func getMaterialsActiveFilter() -> Int {
        return materialsFilters.firstIndex(where: { $0.isActive }) ?? 0
    }

    private func getTips() -> [Types.Material] {
        return materialsProvider.getTips()
    }

    private func getArticles() -> [Types.Material] {
        return materialsProvider.getArticles()
    }

}

extension Int {

    fileprivate var isTipsFilter: Bool {
        return self == 0
    }

}
