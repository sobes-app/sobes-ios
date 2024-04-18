import Foundation

@MainActor
public protocol MaterialsViewModel: ObservableObject {
    func onViewAppear()
}

@MainActor
public final class MaterialsViewModelImpl: MaterialsViewModel {

    public init() {
    }

    public func onViewAppear() {
    }

}
