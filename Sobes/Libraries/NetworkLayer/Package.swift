// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkLayer",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "NetworkLayer",
            targets: ["NetworkLayer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/andriyslyusar/SwiftyKeychainKit", from: "1.0.0-beta.2"),
    ],
    targets: [
        .target(
            name: "NetworkLayer",
            dependencies: ["SwiftyKeychainKit"],
            sources: ["Sources"]
        ),
    ]
)
