// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SymbolEnumCreator",
    products: [
        .executable(name: "SymbolEnumCreator", targets: ["SymbolEnumCreator"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SymbolEnumCreator",
            dependencies: [],
            resources: [
                .copy("Resources")
            ]
        ),
    ]
)
