import SwiftUI
import Types

@MainActor
public protocol MaterialsViewModel: ObservableObject {
    var materials: [Types.Material] { get }
    var filters: [Types.Filter] { get }
    func onViewAppear()
    func onFilterTapped(id: Int)
}

@MainActor
public final class MaterialsViewModelImpl: MaterialsViewModel {

    @Published public var materials: [Types.Material]
    @Published public var filters: [Types.Filter]

    public init() {
        self.materials = []
        self.filters = []
    }

    public func onViewAppear() {
        materials = getDefaultMaterials()
        filters = [
            Filter(id: 0, name: "Тинькофф"),
            Filter(id: 1, name: "Яндекс")
        ]

    }

    public func onFilterTapped(id: Int) {
        filters[id].isActive.toggle()
        if filtersNotActive() {
            materials = getDefaultMaterials()
        } else {
            var filteredMaterials: [Types.Material] = []
            for filter in filters {
                if filter.isActive {
                    filteredMaterials.append(contentsOf: getDefaultMaterials().filter { material in
                        Material.getCompanyName(of: material).contains(filter.name)
                    })
                }
            }
            materials = filteredMaterials
        }
    }

    private func filtersNotActive() -> Bool {
        for filter in filters {
            if filter.isActive {
                return false
            }
        }
        return true
    }

    private func getDefaultMaterials() -> [Types.Material] {
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
            ),
            .article(
                model:
                    Article(
                        id: 2,
                        logo: Image("yandex", bundle: .module),
                        companyName: "GO Practice",
                        author: "GO PRACTICE",
                        text: "Вопросы на собеседовании продакт-менеджера: шаблон и гайд для кандидатов и работодателей"
                    )
            )
        ]
    }

}
