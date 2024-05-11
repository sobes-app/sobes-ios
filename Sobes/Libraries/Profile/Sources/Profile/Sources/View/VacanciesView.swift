import SwiftUI
import UIComponents
import PhotosUI
import Foundation
import Combine

public struct VacanciesView<Model: ProfileViewModel>: View {
    @Environment(\.openURL) var openURL
    
    public init(model: Model, showTabBar: Binding<Bool>) {
        self._model = ObservedObject(wrappedValue: model)
        self._showTabBar = showTabBar
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: Constants.smallStack) {
                BackButton()
                if isLoading {
                    LoadingText(text: "Загружаю")
                }
            }
            VStack(alignment: .leading, spacing: Constants.defSpacing) {
                if model.vacancies.isEmpty && !isLoading {
                    Spacer()
                    EmptyDataView(text: "Пока не нашли подходящие вакансии :(\nПопробуй поискать на сайте компании")
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: Constants.smallStack) {
                            ForEach(model.vacancies) { item in
                                VStack {
                                    vacancyView(item: item)
                                    Rectangle()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 1)
                                        .foregroundColor(Color(.light))
                                } .onTapGesture {
                                    onTap(item: item)
                                }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .padding(.top, Constants.topPadding)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Constants.horizontal)
        .task {
            isLoading = true
            await model.loadAllPages()
            isLoading = false
        }
        .onAppear {
            withAnimation {
                showTabBar = false
            }
        }
        .onDisappear{
            withAnimation {
                showTabBar = true
            }
        }
    }
    
    func onTap(item: Item) {
        openURL(URL(string: item.alternate_url ?? "")!)
    }
    
    func vacancyView(item: Item) -> some View {
        HStack(alignment: .center, spacing: Constants.smallStack) {
            VStack(alignment: .leading, spacing: Constants.smallStack) {
                Text(item.name)
                    .font(Fonts.small.bold())
                Text("Опыт работы: \(item.experience.name)")
                    .font(Fonts.small)
                salaryView(item: item)
                Text(item.employer.name)
                    .font(Fonts.small)
                    .foregroundColor(Color("grey", bundle: .module))
            }
            Spacer()
            Image(systemName: "chevron.right")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    func salaryView(item : Item) -> some View {
        if item.salary?.from != nil && item.salary?.to != nil {
            Text("Зарплата: от \(String(describing: item.salary?.from)) до \(String(describing: item.salary?.to))")
                .font(Fonts.small)
        } else if item.salary?.from != nil {
            Text("Зарплата: от \(String(describing: item.salary?.from))")
                .font(Fonts.small)
        } else if item.salary?.to != nil {
            Text("Зарплата: до \(String(describing: item.salary?.from))")
                .font(Fonts.small)
        }
    }
    
    @State var isEmpty: Bool = false
    @State var isLoading: Bool = false
    @ObservedObject private var model: Model
    @Binding private var showTabBar: Bool
}
