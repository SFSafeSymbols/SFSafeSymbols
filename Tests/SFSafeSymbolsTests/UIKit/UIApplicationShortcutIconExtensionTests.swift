@testable import SFSafeSymbols

#if os(iOS) || targetEnvironment(macCatalyst)

import XCTest

final class UIApplicationShortcutIconExtensionTests: XCTestCase {
    /// Tests, whether the `UIApplicationShortcutIcon` retrieved via SFSafeSymbols is equal to the one retrieved via the `String` initializer
    func testInit() {
        if #available(iOS 13.0, *) {
            for symbol in TestHelper.allSymbolsWithVariants {
                print("Testing validity of \"\(symbol.rawValue)\" via UIApplicationShortcutIcon init")

                let expected = UIApplicationShortcutIcon(systemImageName: symbol.rawValue)
                let actual = UIApplicationShortcutIcon(systemSymbol: symbol)

                XCTAssertEqual(actual, expected)
            }
        } else {
            XCTFail("iOS 13 is required to test SFSafeSymbols.")
        }
    }

    /// Tests whether the `UIApplicationShortcutIcon` equality check used in the main test works properly
    func testTestMechanism() {
        if #available(iOS 13.0, *) {
            let expected = UIApplicationShortcutIcon(systemImageName: TestHelper.sampleSymbolRawValue)
            let actual = UIApplicationShortcutIcon(systemSymbol: TestHelper.sampleSymbol)
            let wrong = UIApplicationShortcutIcon(systemSymbol: TestHelper.sampleSymbolWrongDerivate)

            XCTAssertEqual(actual, expected)
            XCTAssertNotEqual(wrong, expected)
        }
        else {
            XCTFail("iOS 13 is required to test SFSafeSymbols.")
        }
    }
}

#endif
