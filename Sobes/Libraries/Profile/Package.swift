// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Profile",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Profile",
            targets: ["Profile"]),
    ],
    dependencies: [
        .package(path: "Sobes/Sources/Libraries/UIComponents"),
        .package(path: "Sobes/Sources/Libraries/Authorization")
    ],
    targets: [
        .target(
            name: "Profile",
            dependencies: ["UIComponents", "Authorization"],
            sources: ["Sources"],
            resources: [.process("Resources")]
        ),
    ]
)
