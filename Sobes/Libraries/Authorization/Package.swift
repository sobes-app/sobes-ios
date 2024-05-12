// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Authorization",
    defaultLocalization: "ru",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Authorization",
            targets: ["Authorization"]),
    ],
    dependencies: [
        .package(path: "Sobes/Sources/Libraries/UIComponents"),
        .package(path: "Sobes/Sources/Libraries/Providers"),
        .package(path: "Sobes/Sources/Libraries/NetworkLayer"),
        .package(url: "https://github.com/andriyslyusar/SwiftyKeychainKit", from: "1.0.0-beta.2"),
    ],
    targets: [
        .target(
            name: "Authorization",
            dependencies: ["UIComponents", "NetworkLayer", "SwiftyKeychainKit", "Providers"],
            sources: ["Sources"],
            resources: [.process("Resources")]
        )
    ]
)
