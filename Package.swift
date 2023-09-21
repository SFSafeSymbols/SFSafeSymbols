// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SFSafeSymbols",
    platforms: [.iOS(.v11), .tvOS(.v11), .watchOS(.v4), .macOS(.v10_13)],
    products: [
        .library(name: "SFSafeSymbols", targets: ["SFSafeSymbols"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SFSafeSymbols",
            dependencies: [],
            resources: [
                .process("Resources/Symbols.xcassets")
            ]
        ),
        .testTarget(
            name: "SFSafeSymbolsTests",
            dependencies: ["SFSafeSymbols"]
        )
    ]
)
