// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SymbolsGenerator",
    products: [
        .executable(name: "SymbolsGenerator", targets: ["SymbolsGenerator"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SymbolsGenerator",
            dependencies: [],
            resources: [
                .copy("Resources"),
            ]
        ),
    ]
)
