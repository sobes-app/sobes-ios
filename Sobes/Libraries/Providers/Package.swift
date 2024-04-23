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
        .package(path: "Sobes/Sources/Libraries/UIComponents"),
        .package(path: "Sobes/Sources/Libraries/Types"),
    ],
    targets: [
        .target(
            name: "Providers",
            dependencies: ["UIComponents", "Types"],
            sources: ["Sources"],
            resources: [.process("Resources")]
        ),
    ]
)
