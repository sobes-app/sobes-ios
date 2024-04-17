// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UIComponents",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "UIComponents",
            targets: ["UIComponents"]),
    ],
    targets: [
        .target(
            name: "UIComponents",
            sources: ["Sources"],
            resources: [.process("Resources")]
        ),
    ]
)
