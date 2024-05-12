// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Chats",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Chats",
            targets: ["Chats"]),
    ],
    dependencies: [
        .package(path: "Sobes/Sources/Libraries/UIComponents"),
        .package(path: "Sobes/Sources/Libraries/Providers"),
        .package(url: "https://github.com/dkk/WrappingHStack", from: "2.0.0"),
//        .package(url: "https://github.com/daltoniam/Starscream.git", from: "4.0.4"),
        .package(url: "https://github.com/andriyslyusar/SwiftyKeychainKit", from: "1.0.0-beta.2"),
//        .package(url: "https://github.com/Romixery/SwiftStomp.git", from: "1.1.1")
    ],
    targets: [
        .target(
            name: "Chats",
            dependencies: ["UIComponents", "WrappingHStack", "Providers", "SwiftyKeychainKit"],
            sources: ["Sources"],
            resources: [.process("Resources")]
        ),
    ]
)
