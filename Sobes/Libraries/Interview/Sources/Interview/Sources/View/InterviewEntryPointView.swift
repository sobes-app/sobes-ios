import SwiftUI
import UIComponents
import Toolbox

public struct InterviewEntryPointView<Model: InterviewViewModel>: View {

    public init(model: Model) {
        self._model = StateObject(wrappedValue: model)
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                headline
                interviewButtons
                Spacer()
            }
            .fullScreenCover(isPresented: $isPresentingStatiscticsView) {
                InterviewStatisticsView(model: model)
            }
            .fullScreenCover(isPresented: $isPresentingProjectManagerInterview) {
                InterviewQuestionsView(type: .project)
            }
            .fullScreenCover(isPresented: $isPresentingProductManagerInterview) {
                InterviewQuestionsView(type: .product)
            }
            .fullScreenCover(isPresented: $isPresentingBAInterview) {
                InterviewQuestionsView(type: .ba)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 31)
        .onAppear {
            model.onViewAppear()
        }
    }

    @StateObject private var model: Model
    @State private var isPresentingStatiscticsView = false
    @State private var isPresentingBAInterview = false
    @State private var isPresentingProductManagerInterview = false
    @State private var isPresentingProjectManagerInterview = false

    private var headline: some View {
        HStack {
            Text("Раздел\nподготовки")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(Font.custom("CoFoSans-Bold", size: 23))
                .foregroundStyle(.black)
            Spacer()
            statisticsButton
        }
    }

    private var statisticsButton: some View {
        Image(systemName: "chart.xyaxis.line")
            .foregroundColor(.black)
            .padding(15)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(.light))
            }
            .onTapGesture {
                withoutAnimation {
                    isPresentingStatiscticsView = true
                }
            }
    }

    private var interviewButtons: some View {
        VStack(spacing: 16) {
            ChevronButton(model: .button(text: "Менеджер проектов"))
                .onTapGesture {
                    withoutAnimation {
                        isPresentingProjectManagerInterview = true
                    }
                }
            ChevronButton(model: .button(text: "Менеджер продукта"))
                .onTapGesture {
                    withoutAnimation {
                        isPresentingProductManagerInterview = true
                    }
                }
            ChevronButton(model: .button(text: "Бизнес-аналитик"))
                .onTapGesture {
                    withoutAnimation {
                        isPresentingBAInterview = true
                    }
                }
        }
    }

}
