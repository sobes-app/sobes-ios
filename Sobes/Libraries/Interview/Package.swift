// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Interview",
    defaultLocalization: "ru",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Interview",
            targets: ["Interview"]),
    ],
    dependencies: [
        .package(path: "Sobes/Sources/Libraries/UIComponents"),
        .package(path: "Sobes/Sources/Libraries/Types"),
        .package(path: "Sobes/Sources/Libraries/Toolbox"),
        .package(path: "Sobes/Sources/Libraries/Providers"),
    ],
    targets: [
        .target(
            name: "Interview",
            dependencies: ["UIComponents", "Types", "Toolbox", "Providers"],
            sources: ["Sources"],
            resources: [.process("Resources")]
        ),
    ]
)
