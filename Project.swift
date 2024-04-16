import ProjectDescription

let project = Project(
    name: "Sobes",
    organizationName: "FCS",
    packages: [.local(path: "Sobes/Libraries/Authorization")],
    targets: [
        .target(
            name: "Sobes",
            destinations: [.iPhone],
            product: .app,
            bundleId: "FCS.Sobes",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["Sobes/Sources/**"],
            resources: ["Sobes/Resources/**"],
            dependencies: [
                .package(product: "Authorization")
            ]
        ),
    ]
)
