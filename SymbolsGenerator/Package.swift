// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "SymbolsGenerator",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "SymbolsGenerator", targets: ["SymbolsGenerator"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.2.1"))
    ],
    targets: [
        .executableTarget(
            name: "SymbolsGenerator",
            dependencies: [
                .product(name: "OrderedCollections", package: "swift-collections")
            ],
            resources: [
                .copy("Resources"),
            ]
        ),
    ]
)
