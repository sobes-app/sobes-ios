import Foundation
import Types
import Providers

struct Vacancy: Codable {
    let items: [Item]
    let pages: Int
}

struct Item: Codable, Identifiable {
    let id: String
    let name: String
    let area: Area
    let employer: Employer
    let salary: Salary?
    let alternate_url: String?
    let experience: Experience
}

struct Experience: Codable {
    let name: String
}

struct Area: Codable {
    let name: String
}

struct Employer: Codable {
    let id: String
    let name: String
    let logo_urls: [String: String]?
}

struct LogoURL: Codable {
    var original: String
}

struct Salary: Codable {
    let from: Int?
    let to: Int?
    let currency: String?
}

struct EmployerSearch: Codable {
    let items: [Employer]
}

actor VacanciesLoader {
    let baseURL = "https://api.hh.ru/vacancies?"
    
    func fetchEmployerID(withName name: String) async throws -> EmployerSearch {
        guard let url = URL(string: "https://api.hh.ru/employers?text=\(name)&only_with_vacancies=true") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()

        let employerList = try decoder.decode(EmployerSearch.self, from: data)
        return employerList
    }


    func loadPage(_ page: Int, company_id: String) async throws -> Vacancy {
        guard let url = URL(string: "\(baseURL)employer_id=\(company_id)&per_page=100&page=\(page)") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let vacancies = try decoder.decode(Vacancy.self, from: data)
        return vacancies
    }
    
    func getCompaniesIds(companies: [Companies]) async throws -> [String] {
        var idsArray: [String] = []
        for company in companies {
            let array = try await fetchEmployerID(withName: company.rawValue)
            for item in array.items {
                idsArray.append(item.id)
            }
        }
        return idsArray
    }

    func loadAllPages(companies: [Companies], level: Levels, professions: [Professions]) async -> [Item] {
        var vacanciesArray: [Item] = []
        let companiesIds = try? await getCompaniesIds(companies: companies)
        for company in companiesIds ?? [] {
            var page = 0
            var hasMorePages = true
            while hasMorePages {
                do {
                    let vacancies = try await loadPage(page, company_id: company)
                    hasMorePages = vacancies.pages > (page + 1)
                    
                    for item in vacancies.items {
                        if existsProfession(array: professions, name: item.name) {
                            if existsLevel(exp: item.experience.name, level: level) {
                                vacanciesArray.append(item)
                            }
                        }
                    }
                    page += 1
                    
                } catch {
                    hasMorePages = false
                }
            }
        }
        return vacanciesArray
    }

    let professionNames: [Professions: String] = [
        .no: "",
        .product: "Product manager",
        .project: "Project manager",
        .analyst: "Business-analyst"
    ]

    func existsProfession(array: [Professions], name: String) -> Bool {
        let lowercasedName = name.lowercased()
        return array.contains(where: { profession in
            lowercasedName.contains(profession.rawValue) || lowercasedName.contains(professionNames[profession]?.lowercased() ?? "")
        })
    }

    let levelExperience: [Levels: [String]] = [
        .no: [],
        .inter: ["Нет опыта"],
        .jun: ["От 1 до 3 лет"],
        .mid: ["От 1 до 3 лет", "От 3 до 6 лет"],
        .sen: ["От 3 до 6 лет"]
    ]

    func existsLevel(exp: String, level: Levels) -> Bool {
        if let experience = levelExperience[level] {
            return experience.contains(exp)
        }
        return false
    }

    func existsCompany() {

    }
}
