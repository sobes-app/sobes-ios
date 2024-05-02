// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Materials",
    defaultLocalization: "ru",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Materials",
            targets: ["Materials"]),
    ],
    dependencies: [
        .package(path: "Sobes/Sources/Libraries/UIComponents"),
        .package(path: "Sobes/Sources/Libraries/Types"),
        .package(path: "Sobes/Sources/Libraries/Toolbox"),
        .package(path: "Sobes/Sources/Libraries/Providers"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.9.1"),
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.7.2"),
    ],
    targets: [
        .target(
            name: "Materials",
            dependencies: [
                "UIComponents",
                "Types",
                "Toolbox",
                "Providers",
                "Alamofire",
                "SwiftSoup",
            ],
            sources: ["Sources"],
            resources: [.process("Resources")]
        ),
    ]
)
