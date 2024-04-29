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
    ],
    targets: [
        .target(
            name: "Chats",
            dependencies: ["UIComponents", "WrappingHStack", "Providers"],
            sources: ["Sources"],
            resources: [.process("Resources")]
        ),
    ]
)
