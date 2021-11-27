// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SFSafeSymbols",
    platforms: [.iOS(.v10), .tvOS(.v10), .watchOS(.v3), .macOS(.v10_12)],
    products: [
        .library(name: "SFSafeSymbols", targets: ["SFSafeSymbols"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SFSafeSymbols",
            dependencies: []
        ),
        .testTarget(
            name: "SFSafeSymbolsTests",
            dependencies: ["SFSafeSymbols"]
        )
    ]
)
