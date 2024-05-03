import SwiftUI
import UIComponents
import Types

public struct InterviewAssessmentView<Model: InterviewViewModel>: View {

    public init(model: Model, question: String, answer: String) {
        self._model = ObservedObject(wrappedValue: model)
        self.question = question
        self.answer = answer
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Constants.topPadding) {
            BackButton()
            if model.isAssessmentLoading {
                LoadingScreen(placeholder: "Оцениваем ваш ответ...")
            } else {
                if let assessment = model.assessment {
                    loadedView(assessment: assessment)
                } else {
                    Spacer()
                    Text("Извините, не смогли оценить ваш ответ, попробуйте еще раз!")
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .padding(Constants.horizontal)
        .task {
            await model.fetchAssessment(question: question, answer: answer)
        }
    }

    private func loadedView(assessment: InterviewAssessment) -> some View {
        VStack(alignment: .leading, spacing: Constants.topPadding) {
            VStack(alignment: .leading, spacing: Constants.defSpacing) {
                header
                statistics(assessment: assessment)
            }
            improvement(text: assessment.improvement)
        }
    }

    private var header: some View {
        Text("Я оцениваю этот ответ следующим образом:")
            .font(Fonts.heading)
            .foregroundStyle(Color(.accent))
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
    }

    private func statistics(assessment: InterviewAssessment) -> some View {
        VStack(alignment: .leading, spacing: Constants.zeroSpacing) {
            Text("Полнота ответа: ")
                .font(Fonts.main)
                .foregroundColor(.black)
            +
            Text("\(assessment.completeness)%")
                .font(Fonts.mainBold)
                .foregroundColor(Color(.accent))

            Text("Удовлетворительность ответа: ")
                .font(Fonts.main)
                .foregroundColor(.black)
            +
            Text("\(assessment.satisfaction)%")
                .font(Fonts.mainBold)
                .foregroundColor(Color(.accent))

            Text("Итоговая оценка: ")
                .font(Fonts.main)
                .foregroundColor(.black)
            +
            Text("\(String(format: "%.1f", assessment.score))%")
                .font(Fonts.mainBold)
                .foregroundColor(Color(.accent))
        }
    }

    private func improvement(text: String) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Constants.defSpacing) {
                Text("Что можно улучшить:")
                    .font(Fonts.heading)
                    .foregroundStyle(Color(.accent))
                    .multilineTextAlignment(.leading)

                Text(text)
                    .font(Fonts.main)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
                    .textSelection(.enabled)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .scrollIndicators(.hidden)
    }

    @ObservedObject private var model: Model
    private let question: String
    private let answer: String

}
