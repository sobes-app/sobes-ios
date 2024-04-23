// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UIComponents",
    defaultLocalization: "ru",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "UIComponents",
            targets: ["UIComponents"]),
    ],
    dependencies: [
        .package(path: "Sobes/Sources/Libraries/Types"),
        .package(path: "Sobes/Sources/Libraries/Toolbox"),
        .package(url: "https://github.com/dkk/WrappingHStack", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "UIComponents",
            dependencies: ["Types", "Toolbox", "WrappingHStack"],
            sources: ["Sources"],
            resources: [.process("Resources")]
        ),
    ]
)
