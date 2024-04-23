import SwiftUI
import Types
import Toolbox

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

    public init() { }

    public func onViewAppear() {
        materials = getTips()
        filters = [
            Filter(id: 0, name: "Тинькофф"),
            Filter(id: 1, name: "Яндекс")
        ]
        materialsFilters = [
            Filter(id: 0, name: "Статьи", isActive: true),
            Filter(id: 1, name: "Советы")
        ]
    }

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
                                return model.companyName.contains(filter.name)
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
        return [
            .tip(
                model:
                    Tip(
                        id: 0,
                        logo: Image("tinkoff", bundle: .module),
                        companyName: "Тинькофф",
                        author: "Татьяна",
                        role: "Менеджер продукта",
                        text: "Во время собеседования мне не так важно, какой ответ вы дадите на математическую или логическую задачу, я смотрю на ваши размышления, поэтому не стесняйтесь думать вслух"
                    )
            ),
            .tip(
                model:
                    Tip(
                        id: 1,
                        logo: Image("yandex", bundle: .module),
                        companyName: "Яндекс",
                        author: "Артём",
                        role: "Менеджер продукта",
                        text: "Учитесь говорить о своих результатах в формате “Была такая проблема, я сделал это потому что..., это повлияло на целевую метрику вот так”"
                    )
            )
        ]
    }

    private func getArticles() -> [Types.Material] {
        return [
            .article(
                model:
                    Article(
                        id: 0,
                        logo: URL(string: "https://gopractice.ru/skills/product_manager_job_interview/")?.host(),
                        author: "GO PRACTICE",
                        text: "Вопросы на собеседовании продакт-менеджера: шаблон и гайд для кандидатов и работодателей", 
                        url: "https://gopractice.ru/skills/product_manager_job_interview/"
                    )
            )
        ]
    }

}

extension Int {

    fileprivate var isTipsFilter: Bool {
        return self == 0
    }

}
