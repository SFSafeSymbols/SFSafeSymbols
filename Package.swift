// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "SFSafeSymbols",
    platforms: [.iOS(.v11), .tvOS(.v11), .watchOS(.v6), .macOS(.v10_13)],
    products: [
        .library(name: "SFSafeSymbols", type: .static, targets: ["SFSafeSymbols"]),
        .library(name: "SFSafeSymbols-Dynamic", type: .dynamic, targets: ["SFSafeSymbols"])
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
