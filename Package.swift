// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "SFSafeSymbols",
    platforms: [.iOS],
    products: [
        .library(name: "SFSafeSymbols", type: .dynamic, targets: ["SFSafeSymbols"])
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
