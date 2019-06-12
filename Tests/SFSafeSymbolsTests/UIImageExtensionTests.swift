@testable import SFSafeSymbols
import XCTest

class UIImageExtensionTests: XCTestCase {
    func testSimpleInit() {
        if #available(iOS 13.0, *) {
            SFSymbol.allCases.forEach { symbol in
                // If this doesn't crash, everything works fine
                _ = UIImage(systemSymbol: symbol)
            }
        } else {
            XCTFail("iOS 13 is required for SFSafeSymbols.")
        }
    }

    func testInitWithConfiguration() {
        XCTFail("Test fail.")
        if #available(iOS 13.0, *) {
            let configurations = [
                UITraitCollection(forceTouchCapability: .available),
                UITraitCollection(horizontalSizeClass: .compact),
                UITraitCollection(horizontalSizeClass: .regular),
                UITraitCollection(verticalSizeClass: .compact),
                UITraitCollection(verticalSizeClass: .unspecified),
                UITraitCollection(legibilityWeight: .bold),
                UITraitCollection(legibilityWeight: .regular),
                UITraitCollection(legibilityWeight: .unspecified),
            ].map { $0.imageConfiguration }

            SFSymbol.allCases.forEach { symbol in
                configurations.forEach { configuration in
                    // If this doesn't crash, everything works fine
                    _ = UIImage(systemSymbol: symbol, withConfiguration: configuration)
                }
            }
        } else {
            XCTFail("iOS 13 is required for SFSafeSymbols.")
        }
    }

    func testInitWithTraits() {
        if #available(iOS 13.0, *) {
            let traits = [
                UITraitCollection(forceTouchCapability: .available),
                UITraitCollection(horizontalSizeClass: .compact),
                UITraitCollection(horizontalSizeClass: .regular),
                UITraitCollection(verticalSizeClass: .compact),
                UITraitCollection(verticalSizeClass: .unspecified),
                UITraitCollection(legibilityWeight: .bold),
                UITraitCollection(legibilityWeight: .regular),
                UITraitCollection(legibilityWeight: .unspecified),
            ]

            SFSymbol.allCases.forEach { symbol in
                traits.forEach { trait in
                    // If this doesn't crash, everything works fine
                    _ = UIImage(systemSymbol: symbol, compatibleWith: trait)
                }
            }
        } else {
            XCTFail("iOS 13 is required for SFSafeSymbols.")
        }
    }
}
