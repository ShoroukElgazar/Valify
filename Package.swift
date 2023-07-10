// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let buildTests = false

let package = Package(
        name: "Valify",
        defaultLocalization: "en",
        platforms: [
            .macOS(.v10_15),
            .iOS(.v13),
            .tvOS(.v13),
        ],
        products: [
            .library(
                    name: "Valify",
                    targets: ["Valify"]
            )
        ],
        dependencies: [],
        targets: [
            .target(
                    name: "Valify",
                    dependencies: [],
                    path: "Sources"),
            .testTarget(
                name: "ValifyTests",
                dependencies: ["Valify"]),
        ]
)
