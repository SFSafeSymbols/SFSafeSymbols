// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "SFSafeSymbols",
    platforms: [.iOS(.v12), .tvOS(.v12), .watchOS(.v5), .macOS(.v10_14), .visionOS(.v1)],
    products: [
        .library(name: "SFSafeSymbols", targets: ["SFSafeSymbols"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SFSafeSymbols",
            dependencies: [],
            exclude: ["SymbolImages"]
        ),
        .testTarget(
            name: "SFSafeSymbolsTests",
            dependencies: ["SFSafeSymbols"]
        )
    ]
)
