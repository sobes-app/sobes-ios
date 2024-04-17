// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Authorization",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Authorization",
            targets: ["Authorization"]),
    ],
    targets: [
        .target(
            name: "Authorization",
            sources: ["Sources"],
            resources: [.process("Resources")]
        ),
    ]
)
