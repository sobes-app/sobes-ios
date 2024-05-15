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
        .package(url: "https://github.com/AliSoftware/OHHTTPStubs", from: "9.1.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.9.1"),
    ],
    targets: [
        .target(
            name: "NetworkLayer",
            dependencies: ["SwiftyKeychainKit", "Alamofire"],
            sources: ["Sources"]
        ),
        .testTarget(
            name: "NetworkLayerTests",
            dependencies: ["NetworkLayer",
                           .product(name: "OHHTTPStubs", package: "OHHTTPStubs"),
                           .product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs")
            ]
        ),
    ]
)
