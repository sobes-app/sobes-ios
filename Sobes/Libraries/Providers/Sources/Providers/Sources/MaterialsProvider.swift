import SwiftUI
import Types
import NetworkLayer
import SwiftyKeychainKit

public protocol MaterialsProvider {
    func getTips() async -> [Types.Material]
    func getArticles() async -> [Types.Material]
}

public final class MaterialsProviderImpl: MaterialsProvider {

    public init() { }

    public func getTips() async -> [Types.Material] {
        let materialsClient = MaterialsClient(token: try? self.keychain.get(accessTokenKey))
        let result = await materialsClient.getTips()
        switch result {
        case .success(let tips):
            return tips.map {
                .tip(model: Tip(id: $0.id, logo: Image("tinkoff", bundle: .module), company: .tinkoff, author: $0.name, role: $0.profession.profession, text: $0.text))
            }
        case .failure:
            return []
        }
    }

    public func getArticles() async -> [Types.Material] {
        let materialsClient = MaterialsClient(token: try? self.keychain.get(accessTokenKey))
        let result = await materialsClient.getArticles()
        switch result {
        case .success(let articles):
            return articles.map {
                .article(model: Article(id: $0.id, logo: URL(string: $0.link)?.host(), author: $0.author, text: $0.author, url: $0.link))
            }
        case .failure:
            return []
        }
    }

    private let keychain: Keychain = Keychain(service: "com.swifty.keychain")
    private let accessTokenKey = KeychainKey<String>(key: "accessToken")

    private var articles: [Types.Material] = [
        .article(
            model:
                Article(
                    id: 0,
                    logo: URL(string: "https://practicum.yandex.ru/business-analyst/")?.host(),
                    author: "Яндекс Практикум",
                    text: "Курс «Бизнес-аналитик»",
                    url: "https://practicum.yandex.ru/business-analyst/"
                )
        ),
        .article(
            model:
                Article(
                    id: 1,
                    logo: URL(string: "https://habr.com/ru/companies/croc/articles/263693/")?.host(),
                    author: "Хабр",
                    text: "Зачем вообще нужны системы бизнес-аналитики",
                    url: "https://habr.com/ru/companies/croc/articles/263693/"
                )
        ),
        .article(
            model:
                Article(
                    id: 2,
                    logo: URL(string: "https://gopractice.ru/skills/product_manager_job_interview/")?.host(),
                    author: "GO PRACTICE",
                    text: "Вопросы на собеседовании продакт-менеджера: шаблон и гайд для кандидатов и работодателей",
                    url: "https://gopractice.ru/skills/product_manager_job_interview/"
                )
        ),
        .article(
            model:
                Article(
                    id: 3,
                    logo: URL(string: "https://habr.com/ru/companies/oleg-bunin/articles/802901/")?.host(),
                    author: "Хабр",
                    text: "Чтобы запустить обмен знаниями в командах, надо всего лишь…",
                    url: "https://habr.com/ru/companies/oleg-bunin/articles/802901/"
                )
        ),
        .article(
            model:
                Article(
                    id: 4,
                    logo: URL(string: "https://vc.ru/hr/501462-top-50-voprosov-na-tehnicheskom-sobesedovanii-dlya-biznes-analitika")?.host(),
                    author: "VC.ru",
                    text: "Топ-50 вопросов на техническом собеседовании для бизнес-аналитика",
                    url: "https://vc.ru/hr/501462-top-50-voprosov-na-tehnicheskom-sobesedovanii-dlya-biznes-analitika"
                )
        ),
        .article(
            model:
                Article(
                    id: 5,
                    logo: URL(string: "https://www.guru99.com/ru/business-analyst-interview-question.html")?.host(),
                    author: "Guru99",
                    text: "100+ вопросов и ответов на собеседовании с бизнес-аналитиками (2024 г.)",
                    url: "https://www.guru99.com/ru/business-analyst-interview-question.html"
                )
        ),
        .article(
            model:
                Article(
                    id: 6,
                    logo: URL(string: "https://habr.com/ru/companies/stm_labs/articles/793414/")?.host(),
                    author: "Хабр",
                    text: "Собеседования аналитиков: кого, куда, как и почему",
                    url: "https://habr.com/ru/companies/stm_labs/articles/793414/"
                )
        ),
        .article(
            model:
                Article(
                    id: 7,
                    logo: URL(string: "https://habr.com/ru/companies/icanchoose/articles/326994/")?.host(),
                    author: "Хабр",
                    text: "Гид для начинающего project-менеджера: управляй велосипедом, который горит",
                    url: "https://habr.com/ru/companies/icanchoose/articles/326994/"
                )
        ),
        .article(
            model:
                Article(
                    id: 8,
                    logo: URL(string: "https://skillbox.ru/media/management/kak_stat_menedzherom_proekta_novichku/")?.host(),
                    author: "Skillbox",
                    text: "Как стать менеджером проекта: можно ли учиться самому и как найти работу",
                    url: "https://skillbox.ru/media/management/kak_stat_menedzherom_proekta_novichku/"
                )
        ),
        .article(
            model:
                Article(
                    id: 9,
                    logo: URL(string: "https://blog.skillfactory.ru/poleznye-resursy-dlya-vseh-kto-interesuetsya-it/")?.host(),
                    author: "SkillFactory",
                    text: "Полезные ресурсы для всех, кто интересуется IT",
                    url: "https://blog.skillfactory.ru/poleznye-resursy-dlya-vseh-kto-interesuetsya-it/"
                )
        ),
        .article(
            model:
                Article(
                    id: 10,
                    logo: URL(string: "https://qarocks.ru/5-ba-trends/")?.host(),
                    author: "QaRocks",
                    text: "5 тенденций в будущем бизнес-анализа",
                    url: "https://qarocks.ru/5-ba-trends/"
                )
        ),
        .article(
            model:
                Article(
                    id: 11,
                    logo: URL(string: "https://journal.tinkoff.ru/business-analitik/")?.host(),
                    author: "Tinkoff Journal",
                    text: "Как я уволилась с завода и стала бизнес-аналитиком",
                    url: "https://journal.tinkoff.ru/business-analitik/"
                )
        ),
        .article(
            model:
                Article(
                    id: 12,
                    logo: URL(string: "https://habr.com/ru/companies/naumen/articles/810157/")?.host(),
                    author: "Хабр",
                    text: "Как я из маркетинга перешла в бизнес-анализ",
                    url: "https://habr.com/ru/companies/naumen/articles/810157/"
                )
        ),
    ]

    private var tips: [Types.Material] = [
        .tip(model:
                Tip(
                    id: 0,
                    logo: Image("tinkoff", bundle: .module),
                    company: .tinkoff,
                    author: "Татьяна",
                    role: "Менеджер продукта",
                    text: "Во время собеседования мне не так важно, какой ответ вы дадите на математическую или логическую задачу, я смотрю на ваши размышления, поэтому не стесняйтесь думать вслух"
                )
            ),
        .tip(model:
                Tip(
                    id: 1,
                    logo: Image("yandex", bundle: .module),
                    company: .yandex,
                    author: "Артём",
                    role: "Менеджер продукта",
                    text: "Учитесь говорить о своих результатах в формате “Была такая проблема, я сделал это потому что..., это повлияло на целевую метрику вот так”"
                )
            ),
        .tip(model:
                Tip(
                    id: 2,
                    logo: Image("yandex", bundle: .module),
                    company: .yandex,
                    author: "Диана",
                    role: "Ведущий менеджер проектов",
                    text: "Важно полностью понимать, что является конечной целью проекта. Это поможет правильно расставить приоритеты и обеспечить, что вся команда работает над достижением общей цели"
                )
            ),
        .tip(model:
                Tip(
                    id: 3,
                    logo: Image("yandex", bundle: .module),
                    company: .yandex,
                    author: "Диана",
                    role: "Ведущий менеджер проектов",
                    text: "Обеспечьте открытые и частые каналы общения с вашей командой, заказчиками и другими заинтересованными сторонами. Важно держать всех в курсе изменений и прогресса проекта"
                )
            ),
        .tip(model:
                Tip(
                    id: 4,
                    logo: Image("yandex", bundle: .module),
                    company: .yandex,
                    author: "Диана",
                    role: "Ведущий менеджер проектов",
                    text: "Всегда планируйте на случай непредвиденных обстоятельств и имейте план действий на случай рисков. Риск-менеджмент является критическим аспектом в управлении проектами"
                )
            ),
        .tip(model:
                Tip(
                    id: 5,
                    logo: Image("yandex", bundle: .module),
                    company: .yandex,
                    author: "Денис",
                    role: "Старший менеджер проектов",
                    text: "Понимайте сильные стороны и слабости вашей команды, чтобы эффективно распределять задачи. Правильное делегирование не только повышает эффективность, но и мотивирует команду"
                )
            ),
        .tip(model:
                Tip(
                    id: 6,
                    logo: Image("yandex", bundle: .module),
                    company: .yandex,
                    author: "Денис",
                    role: "Старший менеджер проектов",
                    text: "После завершения каждого проекта проводите анализ того, что было сделано хорошо, и что можно улучшить в будущем"
                )
            ),
        .tip(model:
                Tip(
                    id: 7,
                    logo: Image("yandex", bundle: .module),
                    company: .yandex,
                    author: "Анжелика",
                    role: "Менеджер проектов",
                    text: "Постоянно развивайтесь как профессионал, уделяя внимание как личностному, так и профессиональному росту. Также поощряйте свою команду к обучению и развитию навыков"
                )
            ),
        .tip(model:
                Tip(
                    id: 8,
                    logo: Image("yandex", bundle: .module),
                    company: .yandex,
                    author: "Анжелика",
                    role: "Менеджер проектов",
                    text: "Будьте готовы к изменениям. Проекты редко идут строго по плану. Гибкость и способность адаптироваться к изменяющимся условиям могут определить успех или неудачу проекта"
                )
            ),
        .tip(model:
                Tip(
                    id: 9,
                    logo: Image("yandex", bundle: .module),
                    company: .yandex,
                    author: "Алиса",
                    role: "Менеджер продукта",
                    text: "Слушайте своих пользователей, понимание их потребностей является ключом к созданию успешного продукта"
                )
            ),
        .tip(model:
                Tip(
                    id: 10,
                    logo: Image("yandex", bundle: .module),
                    company: .yandex,
                    author: "Алиса",
                    role: "Менеджер продукта",
                    text: "Определяйте и тестируйте гипотезы быстро, скорость в изучении и адаптации может значительно увеличить шансы на успех"
                )
            ),
        .tip(model:
                Tip(
                    id: 11,
                    logo: Image("yandex", bundle: .module),
                    company: .yandex,
                    author: "Алиса",
                    role: "Менеджер продукта",
                    text: "Балансируйте между инновациями и проверенными решениями – это поможет уменьшить риски и увеличить потенциал продукта"
                )
            ),
        .tip(model:
                Tip(
                    id: 12,
                    logo: Image("yandex", bundle: .module),
                    company: .yandex,
                    author: "Саша",
                    role: "Ведущий менеджер продукта",
                    text: "Учитеся на ошибках конкурентов, чтобы избежать схожих проблем в вашем продукте"
                )
            ),
        .tip(model:
                Tip(
                    id: 13,
                    logo: Image("yandex", bundle: .module),
                    company: .yandex,
                    author: "Саша",
                    role: "Ведущий менеджер продукта",
                    text: "Сотрудничайте с разработчиками; хорошие отношения и понимание между командами могут значительно ускорить разработку"
                )
            ),
        .tip(model:
                Tip(
                    id: 14,
                    logo: Image("yandex", bundle: .module),
                    company: .yandex,
                    author: "Саша",
                    role: "Ведущий менеджер продукта",
                    text: "Изучите продукт и компанию: проведите тщательное исследование продуктов компании, их рынков и конкурентов, чтобы показать свою заинтересованность и понимание бизнеса"
                )
            ),
        .tip(model:
                Tip(
                    id: 15,
                    logo: Image("tinkoff", bundle: .module),
                    company: .tinkoff,
                    author: "Алексей",
                    role: "Старший менеджер продукта",
                    text: "Продемонстрируйте свои аналитические навыки: Подготовьте примеры из вашего опыта, когда вы анализировали данные для принятия продуктовых решений или улучшения функциональности продукта."
                )
            ),
        .tip(model:
                Tip(
                    id: 16,
                    logo: Image("tinkoff", bundle: .module),
                    company: .tinkoff,
                    author: "Алексей",
                    role: "Старший менеджер продукта",
                    text: "Расскажите о своём опыте работы с пользователем, поделитесь историями о том, как вы взаимодействовали с пользователями для получения обратной связи и как это повлияло на развитие продукта"
                )
            ),
        .tip(model:
                Tip(
                    id: 17,
                    logo: Image("tinkoff", bundle: .module),
                    company: .tinkoff,
                    author: "Алексей",
                    role: "Старший менеджер продукта",
                    text: "Задавая вопросы о культуре компании, ожиданиях от данной роли и направлениях развития продукта, вы покажете свой интерес и готовность быть вовлеченным в работу компании"
                )
            ),
        .tip(model:
                Tip(
                    id: 18,
                    logo: Image("tinkoff", bundle: .module),
                    company: .tinkoff,
                    author: "Алексей",
                    role: "Старший менеджер продукта",
                    text: "Рекомендации от предыдущих работодателей или коллег могут сыграть важную роль, подчеркнув вашу компетентность и способность работать в команде"
                )
            ),
        .tip(model:
                Tip(
                    id: 19,
                    logo: Image("tinkoff", bundle: .module),
                    company: .tinkoff,
                    author: "Алексей",
                    role: "Старший менеджер продукта",
                    text: "Будьте готовы обсудить, как вы разрабатывали или могли бы разработать стратегии для роста или улучшения продукта"
                )
            ),
        .tip(model:
                Tip(
                    id: 20,
                    logo: Image("tinkoff", bundle: .module),
                    company: .tinkoff,
                    author: "Алексей",
                    role: "Старший менеджер продукта",
                    text: "Будьте готовы обсудить, как вы разрабатывали или могли бы разработать стратегии для роста или улучшения продукта"
                )
            ),
        .tip(model:
                Tip(
                    id: 21,
                    logo: Image("tinkoff", bundle: .module),
                    company: .tinkoff,
                    author: "Сергей",
                    role: "Бизнес-аналитик",
                    text: "Сначала данные, потом интуиция: всегда ищите и анализируйте данные перед тем, как принимать какие-либо предположения или решения"
                )
            ),
        .tip(model:
                Tip(
                    id: 22,
                    logo: Image("tinkoff", bundle: .module),
                    company: .tinkoff,
                    author: "Сергей",
                    role: "Бизнес-аналитик",
                    text: "Мастерите Excel и SQL – эти инструменты являются вашими лучшими друзьями в анализе данных и помогут вам быстро находить ответы на сложные вопросы"
                )
            ),
        .tip(model:
                Tip(
                    id: 23,
                    logo: Image("tinkoff", bundle: .module),
                    company: .tinkoff,
                    author: "Сергей",
                    role: "Бизнес-аналитик",
                    text: "Не бойтесь задавать вопросы, вопросы помогают уточнить и углубить ваше понимание задач и дадут возможность улучшить аналитические процедуры"
                )
            ),
        .tip(model:
                Tip(
                    id: 24,
                    logo: Image("tinkoff", bundle: .module),
                    company: .tinkoff,
                    author: "Сергей",
                    role: "Бизнес-аналитик",
                    text: "Отмечайте свои маленькие победы, цените каждые улучшения и успехи в работе, это помогает поддерживать мотивацию и стремление к развитию"
                )
            ),
        .tip(model:
                Tip(
                    id: 25,
                    logo: Image("tinkoff", bundle: .module),
                    company: .tinkoff,
                    author: "Сергей",
                    role: "Бизнес-аналитик",
                    text: "Изучите визуализацию данных: научитесь эффективно представлять данные с помощью инструментов визуализации, таких как Tableau или PowerBI, чтобы ваши выводы были понятны для всех"
                )
            ),
    ]

}
