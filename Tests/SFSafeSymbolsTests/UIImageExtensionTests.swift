@testable import SFSafeSymbols

#if !os(watchOS)

import XCTest

class UIImageExtensionTests: XCTestCase {
    func testSimpleInit() {
        if #available(iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            SFSymbol.allCases.forEach { symbol in
                // If this doesn't crash, everything works fine
                _ = UIImage(systemSymbol: symbol)
            }
        } else {
            XCTFail("iOS 13 or tvOS 13 is required to test  SFSafeSymbols.")
        }
    }

    func testInitWithConfiguration() {
        if #available(iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
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
            XCTFail("iOS 13 or tvOS 13 is required to test  SFSafeSymbols.")
        }
    }
}

#endif
