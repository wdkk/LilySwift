// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LilySwift",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "LilySwift",
            targets: [
                "LilySwift"
            ]
        )
    ],
    targets: [
        .target(
            name: "LilySwift",
            dependencies: [],
            path: "./Sources/",
            swiftSettings: [
                .define("DEBUG", .when( platforms:[.iOS, .macOS, .macCatalyst], configuration:.debug))
            ]
        )
    ]
)
