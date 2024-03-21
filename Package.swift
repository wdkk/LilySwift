// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LilySwift",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .macCatalyst(.v16),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "LilySwift",
            targets: [
                "LilySwift",
                "LilySwiftAlias"
            ]
        )
    ],
    targets: [
        .target(
            name: "LilySwift",
            dependencies: [],
            path: "./Sources/",
            swiftSettings: [
                .define( "DEBUG", .when( platforms:[.iOS, .macOS, .macCatalyst, .visionOS], configuration:.debug ) )
            ]
        ),
        .target(
            name: "LilySwiftAlias",
            dependencies: [ "LilySwift" ],
            path: "./Aliases/",
            swiftSettings: [
                .define( "DEBUG", .when( platforms:[.iOS, .macOS, .macCatalyst, .visionOS], configuration:.debug ) )
            ]
        )
    ]
)
