// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Providers",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Providers",
            targets: ["Providers"]),
    ],
    dependencies: [
        .package(path: "Sobes/Sources/Libraries/Types"),
        .package(path: "Sobes/Sources/Libraries/NetworkLayer"),
        .package(url: "https://github.com/andriyslyusar/SwiftyKeychainKit", from: "1.0.0-beta.2"),
    ],
    targets: [
        .target(
            name: "Providers",
            dependencies: ["Types", "SwiftyKeychainKit", "NetworkLayer"],
            sources: ["Sources"]
        ),
    ]
)
