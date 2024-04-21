// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Authorization",
    defaultLocalization: "ru",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Authorization",
            targets: ["Authorization"]),
    ],
    dependencies: [
        .package(path: "Sobes/Sources/Libraries/UIComponents"),
    ],
    targets: [
        .target(
            name: "Authorization",
            dependencies: ["UIComponents"],
            sources: ["Sources"],
            resources: [.process("Resources")]
        ),
    ]
)
