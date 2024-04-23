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
        .package(url: "https://github.com/globulus/swiftui-gif", .upToNextMajor(from: "1.0.1")),
        .local(path: "Sobes/Libraries/Interview"),
        .local(path: "Sobes/Libraries/Toolbox"),
        .package(url: "https://github.com/dkk/WrappingHStack", .upToNextMajor(from: "2.0.0"))
    ],
    targets: [
        .target(
            name: "Sobes",
            destinations: [.iPhone],
            product: .app,
            bundleId: "FCS.Sobes",
            deploymentTargets: .iOS("16.0"),
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
                .package(product: "Toolbox"),
                .package(product: "WrappingHStack", type: .runtime),
                .package(product: "Providers"),
                .package(product: "SwiftUIGIF", type: .runtime)
                
            ]
        ),
    ]
)
