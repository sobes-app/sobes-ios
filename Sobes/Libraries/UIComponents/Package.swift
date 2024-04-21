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
    ],
    targets: [
        .target(
            name: "UIComponents",
            dependencies: ["Types"],
            sources: ["Sources"],
            resources: [.process("Resources")]
        ),
    ]
)
