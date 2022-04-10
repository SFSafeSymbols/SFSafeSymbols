// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SymbolsGenerator",
    products: [
        .executable(name: "SymbolsGenerator", targets: ["SymbolsGenerator"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(
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
