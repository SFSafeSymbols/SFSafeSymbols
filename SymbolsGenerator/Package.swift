// swift-tools-version:6.3

import PackageDescription

let package = Package(
    name: "SymbolsGenerator",
    platforms: [
        .macOS(.v26)
    ],
    products: [
        .executable(name: "SymbolsGenerator", targets: ["SymbolsGenerator"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.4.1")),
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.7.1")),
        .package(url: "https://github.com/mxcl/Version.git", .upToNextMajor(from: "2.2.0")),
    ],
    targets: [
        .executableTarget(
            name: "SymbolsGenerator",
            dependencies: [
                .product(name: "OrderedCollections", package: "swift-collections"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Version", package: "Version"),
            ],
            resources: [
                .copy("Resources"),
            ]
        ),
    ]
)
