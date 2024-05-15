import ProjectDescription

let project = Project(
    name: "Sobes",
    organizationName: "FCS",
    packages: [
        .local(path: "Sobes/Libraries/Authorization"),
        .local(path: "Sobes/Libraries/UIComponents"),
        .local(path: "Sobes/Libraries/Profile"),
        .local(path: "Sobes/Libraries/Chats"),
        .local(path: "Sobes/Libraries/Materials"),
        .local(path: "Sobes/Libraries/Types"),
        .local(path: "Sobes/Libraries/Providers"),
        .local(path: "Sobes/Libraries/Interview"),
        .local(path: "Sobes/Libraries/Toolbox"),
		.local(path: "Sobes/Libraries/NetworkLayer"),
        .package(url: "https://github.com/globulus/swiftui-gif", .upToNextMajor(from: "1.0.1")),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.9.1")),
        .package(url: "https://github.com/scinfu/SwiftSoup.git", .upToNextMajor(from: "2.7.2")),
        .package(url: "https://github.com/dkk/WrappingHStack", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/andriyslyusar/SwiftyKeychainKit", .upToNextMajor(from: "1.0.0-beta.2")),
        .package(url: "https://github.com/daltoniam/Starscream.git", .upToNextMajor(from:"4.0.4")),
        .package(url: "https://github.com/AliSoftware/OHHTTPStubs", .upToNextMajor(from:"9.1.0")),
//        .package(url: "https://github.com/Romixery/SwiftStomp.git", .upToNextMajor(from: "1.1.1"))

    ],
    targets: [
        .target(
            name: "Sobes",
            destinations: [.iPhone],
            product: .app,
            bundleId: "FCS.Sobes",
            deploymentTargets: .iOS("17.0"),
            infoPlist: "Sobes/Sources/Sobes-Info.plist",
            sources: ["Sobes/Sources/**"],
            resources: ["Sobes/Resources/**"],
            dependencies: [
                .package(product: "Authorization"),
                .package(product: "UIComponents"),
                .package(product: "Chats"),
                .package(product: "Materials"),
                .package(product: "Types"),
                .package(product: "Profile"),
                .package(product: "Interview"),
                .package(product: "NetworkLayer"),
                .package(product: "Toolbox"),
                .package(product: "WrappingHStack", type: .runtime),
                .package(product: "Providers"),
                .package(product: "SwiftUIGIF", type: .runtime),
                .package(product: "SwiftyKeychainKit", type: .runtime),
                .package(product: "Alamofire", type: .runtime),
                .package(product: "SwiftSoup", type: .runtime),
                .package(product: "Starscream", type: .runtime),
                .package(product: "OHHTTPStubs", type: .runtime)
//                .package(product: "SwiftStomp", type: .runtime),
            ]
        ),
    ]
)
