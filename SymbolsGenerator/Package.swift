// swift-tools-version:6.2

import Foundation
import PackageDescription

/// Module interface and linker stub for the private SFSymbols framework, which provides the symbols' metadata.
let privateFrameworks = URL(fileURLWithPath: #filePath).deletingLastPathComponent().appending(path: "PrivateFrameworks").path

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
        .package(url: "https://github.com/swiftlang/swift-subprocess.git", .upToNextMajor(from: "1.0.2")),
        .package(url: "https://github.com/ainame/Swift-WebP.git", .upToNextMajor(from: "0.7.0")),
    ],
    targets: [
        .executableTarget(
            name: "SymbolsGenerator",
            dependencies: [
                .product(name: "OrderedCollections", package: "swift-collections"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Version", package: "Version"),
                .product(name: "Subprocess", package: "swift-subprocess"),
                .product(name: "WebP", package: "Swift-WebP"),
            ],
            swiftSettings: [
                .unsafeFlags(["-I", "\(privateFrameworks)/Modules"]),
            ],
            linkerSettings: [
                .unsafeFlags(["-F", "\(privateFrameworks)/Frameworks", "-framework", "SFSymbols"]),
            ]
        ),
    ]
)
