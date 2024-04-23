import SwiftUI
import Types

@MainActor
public protocol InterviewViewModel: ObservableObject {
    func onViewAppear()
    func shuffleQuestions()
}

@MainActor
public final class InterviewViewModelImpl: InterviewViewModel {

    public init() {
    }

    public func onViewAppear() {
    }

    public func shuffleQuestions() {

    }

}
