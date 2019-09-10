@testable import SFSafeSymbols

#if !os(watchOS)

import XCTest

class UIImageExtensionTests: XCTestCase {
    func testSimpleInit() {
        if #available(iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            SFSymbol.allCases.forEach { symbol in
                // If this doesn't crash, everything works fine
                print("Testing existence of \(symbol) via UIImage init")
                _ = UIImage(systemSymbol: symbol)
            }
        } else {
            XCTFail("iOS 13 or tvOS 13 is required to test  SFSafeSymbols.")
        }
    }

    func testInitWithConfiguration() {
        if #available(iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            // Get many configurations
            var manyConfigurations: [UIImage.Configuration] = [
                UIImage.SymbolConfiguration(pointSize: 8),
                UIImage.SymbolConfiguration(pointSize: 10),
                UIImage.SymbolConfiguration(pointSize: 12),
                UIImage.SymbolConfiguration(pointSize: 14),
                UIImage.SymbolConfiguration(pointSize: 16),
                UIImage.SymbolConfiguration(pointSize: 20),
                UIImage.SymbolConfiguration(pointSize: 30),
                UIImage.SymbolConfiguration(pointSize: 50),
                UIImage.SymbolConfiguration(pointSize: 100),
                UIImage.SymbolConfiguration(scale: .unspecified),
                UIImage.SymbolConfiguration(scale: .default),
                UIImage.SymbolConfiguration(scale: .small),
                UIImage.SymbolConfiguration(scale: .medium),
                UIImage.SymbolConfiguration(scale: .large),
                UIImage.SymbolConfiguration(weight: .unspecified),
                UIImage.SymbolConfiguration(weight: .ultraLight),
                UIImage.SymbolConfiguration(weight: .thin),
                UIImage.SymbolConfiguration(weight: .light),
                UIImage.SymbolConfiguration(weight: .regular),
                UIImage.SymbolConfiguration(weight: .medium),
                UIImage.SymbolConfiguration(weight: .semibold),
                UIImage.SymbolConfiguration(weight: .bold),
                UIImage.SymbolConfiguration(weight: .heavy),
                UIImage.SymbolConfiguration(weight: .black),
                UIImage.SymbolConfiguration(pointSize: 10, weight: .medium),
                UIImage.SymbolConfiguration(pointSize: 20, weight: .medium),
                UIImage.SymbolConfiguration(pointSize: 10, weight: .black),
                UIImage.SymbolConfiguration(pointSize: 20, weight: .black),
                UIImage.SymbolConfiguration(pointSize: 10, weight: .medium, scale: .large),
                UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .large),
                UIImage.SymbolConfiguration(pointSize: 10, weight: .black, scale: .small),
                UIImage.SymbolConfiguration(pointSize: 20, weight: .black, scale: .small),
            ]

            manyConfigurations.append(
                contentsOf: [
                    UITraitCollection(forceTouchCapability: .available),
                    UITraitCollection(horizontalSizeClass: .compact),
                    UITraitCollection(horizontalSizeClass: .regular),
                    UITraitCollection(verticalSizeClass: .compact),
                    UITraitCollection(verticalSizeClass: .unspecified),
                    UITraitCollection(legibilityWeight: .bold),
                    UITraitCollection(legibilityWeight: .regular),
                    UITraitCollection(legibilityWeight: .unspecified)
                ].map { $0.imageConfiguration }
            )

            // Go through cross product: symbols & configs
            SFSymbol.allCases.forEach { symbol in
                manyConfigurations.forEach { configuration in
                    // If this doesn't crash, everything works fine
                    print("Testing existence of \(symbol) with configuration \(configuration)")
                    _ = UIImage(systemSymbol: symbol, withConfiguration: configuration)
                }
            }
        } else {
            XCTFail("iOS 13 or tvOS 13 is required to test  SFSafeSymbols.")
        }
    }
}

#endif
