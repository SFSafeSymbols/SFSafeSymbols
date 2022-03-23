@testable import SFSafeSymbols

#if !os(watchOS)

import XCTest

#if canImport(SwiftUI)

import SwiftUI

class ImageExtensionTests: XCTestCase {
    /// Tests, whether the `Image` retrieved via SFSafeSymbols is equal to the one retrieved via the `String` initializer
    func testInit() {
        if #available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *) {
            for symbol in TestHelper.allSymbolsWithVariants {
                print("Testing validity of \"\(symbol.rawValue)\" via Image init")

                let expected = Image(systemName: symbol.rawValue)
                let actual = Image(systemSymbol: symbol)

                XCTAssertEqual(actual, expected)
            }
        } else {
            XCTFail("iOS 13, macOS 11.0, tvOS 13 or watchOS 6.0 is required to test SFSafeSymbols.")
        }
    }

    /// Tests whether the `Image` equality check used in the main test works properly
    func testTestMechanism() {
        if #available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *) {
            let expected = Image(systemName: TestHelper.sampleSymbolRawValue)
            let actual = Image(systemSymbol: TestHelper.sampleSymbol)
            let wrong = Image(systemSymbol: TestHelper.sampleSymbolWrongDerivate)

            XCTAssertEqual(actual, expected)
            XCTAssertNotEqual(wrong, expected)
        }
        else {
            XCTFail("iOS 13, macOS 11.0, tvOS 13 or watchOS 6.0 is required to test SFSafeSymbols.")
        }
    }
}

#else

class JustFail: XCTestCase {
    func justFail() {
        XCTFail("SwiftUI should be available when testing.")
    }
}

#endif

#endif
