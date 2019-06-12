@testable import SFSafeSymbols
import XCTest

@available(iOS 13.0, *)
class UIImageExtensionTests: XCTestCase {
    func testSimpleInit() {
        SFSymbol.allCases.forEach { symbol in
            // If this doesn't crash, everything works fine
            _ = UIImage(systemSymbol: symbol)
        }
    }

    func testInitWithConfiguration() {
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
    }

    func testInitWithTraits() {
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
    }
}
