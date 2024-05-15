import Foundation
import Types
import Providers
import NetworkLayer

@MainActor
public protocol ProfileViewModel: ObservableObject {

    var professions: [Professions] { get set }
    var companies: [Companies] { get set }
    var vacancies: [Item] { get set }
    var level: Types.Levels { get set }
    var stepsCount: Double { get set }

    var isLoading: Bool { get set }
    var isError: Bool { get set }

    func getProfileName() -> String
    func getProfileLevel() -> String
    func getProfileProfessions() -> String
    func getProfileCompanies() -> String
    func changePassword(oldPassword: String, newPassword: String) async -> Bool
    func setProfileInfo() async -> Bool
    func updateProfile(level: String?, professions: [String]?, companies: [String]?) async -> Bool
    func loadAllPages() async

    func onViewAppear() async -> Bool
    func onLogoutTap() async
    func sendFeedback(content: String) async -> Bool

    func isInfoNotEmpty() -> Bool
}

@MainActor
public final class ProfileViewModelImpl: ProfileViewModel {
    
    @Published public var isLoading: Bool = false
    @Published public var isError: Bool = false
    
    @Published var profile: Profile?
    
    @Published public var professions: [Professions] = []
    @Published public var companies: [Companies] = []
    @Published public var level: Types.Levels = .no
    @Published public var vacancies: [Item] = []
    @Published public var stepsCount: Double = 3
    
    public init(profileProvider: ProfileProvider) {
        self.profileProvider = profileProvider
    }
    
    public func changePassword(oldPassword: String, newPassword: String) async -> Bool {
        isLoading = true
        let success = await profileProvider.changePassword(oldPassword: oldPassword, newPassword: newPassword)
        isLoading = false
        return success
    }
    
    public func getProfileName() -> String {
        return profile?.name ?? ""
    }
    
    public func getProfileLevel() -> String {
        return level.rawValue
    }
    
    public func getProfileProfessions() -> String {
        return professions.map { $0.rawValue }.joined(separator: ", ")
    }
    
    public func getProfileCompanies() -> String {
        return companies.map { $0.rawValue }.joined(separator: ", ")
    }
    
    public func onViewAppear() async -> Bool{
        var success = true
        if profile == nil {
            success = await setProfile()
        }
        return success
    }
    
    func setProfile() async -> Bool {
        isLoading = true
        isError = false
        defer { isLoading = false }
        
        let result = await profileProvider.getProfile()
        switch result {
        case .success(let success):
            profile = success
            companies = profile?.companies ?? []
            professions = profile?.professions ?? []
            level = profile?.level ?? .no
            return true
        case .failure(let failure):
            return await setError(failure: failure)
        }
    }
    
    public func onLogoutTap() async {
        await profileProvider.logout()
        profile = nil
    }
    
    public func isInfoNotEmpty() -> Bool {
        profile?.level.rawValue.isEmpty == false
    }
    
    public func sendFeedback(content: String) async -> Bool {
        isLoading = true
        isError = false
        defer { isLoading = false }
        
        let result = await profileProvider.sendFeedback(content: content)
        if result == false {
            isError = true
            return false
        }
        return true
    }
    
    public func setProfileInfo() async -> Bool {
        isLoading = true
        isError = false
        defer { isLoading = false }
        
        let com = Profile.stringArrayComp(of: companies)
        let pro = Profile.stringArrayProf(of: professions)
        let result = await profileProvider.createProfile(exp: level.rawValue, comp: com, prof: pro)
        
        switch result {
        case .success:
            let success = await setProfile()
            return success
        case .failure(let failure):
            return await setError(failure: failure)
        }
    }
    
    public func updateProfile(level: String? = nil, professions: [String]? = nil, companies: [String]? = nil) async -> Bool {
        isLoading = true
        isError = false
        defer { isLoading = false }
        
        let result = await profileProvider.updateProfile(level: level, professions: professions, companies: companies)
        switch result {
        case .success:
            let success = await setProfile()
            return success
        case .failure(let failure):
            return await setError(failure: failure)
        }
    }
    
    private func updateProfile() async -> Bool {
        let request = await profileProvider.getProfile()
        switch request {
        case .success(let profile):
            isLoading = false
            self.profile = profile
        case .failure:
            isLoading = false
            isError = true
        }
        return true
    }
    
    func setError(failure: CustomError) async -> Bool {
        switch failure {
        case .error, .empty:
            isError = true
            return false
        }
            
    }
    
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
    
    public func loadAllPages() async {
        let companiesIds = try? await getCompaniesIds(companies: companies)
        for company in companiesIds ?? [] {
            var page = 0
            var hasMorePages = true
            while hasMorePages {
                do {
                    let vacancies = try await loadPage(page, company_id: company)
                    hasMorePages = vacancies.pages > (page + 1)
                    self.vacancies.append(contentsOf: vacancies.items.filter { item in
                        existsProfession(array: professions, name: item.name) && existsLevel(exp: item.experience.name, level: level)
                    })
                    page += 1
                    
                } catch {
                    hasMorePages = false
                }
            }
        }
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
    
    private let profileProvider: ProfileProvider
    let baseURL = "https://api.hh.ru/vacancies?"

}
