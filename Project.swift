import ProjectDescription

let project = Project(
    name: "Sobes",
    organizationName: "FCS",
    packages: [
        .local(path: "Sobes/Libraries/Authorization"),
        .local(path: "Sobes/Libraries/UIComponents"),
        .local(path: "Sobes/Libraries/Profile"),
        .local(path: "Sobes/Libraries/Chats")
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
                .package(product: "Profile"),
                .package(product: "Chats")
            ]
        ),
    ]
)
