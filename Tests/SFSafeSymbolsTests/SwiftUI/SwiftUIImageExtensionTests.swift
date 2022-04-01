@testable import SFSafeSymbols

#if !os(watchOS)

import XCTest

#if canImport(SwiftUI)

import SwiftUI

class ImageExtensionTests: XCTestCase {
    /// Tests, whether the symbol retrieved via SFSafeSymbols is equal to the one retrieved manually
    func testInit() {
        if #available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *) {
            for symbol in (SFSymbol.allSymbols.sorted { $0.rawValue < $1.rawValue }) {
                let expected = Image(systemName: symbol.rawValue)
                let actual = Image(systemSymbol: symbol)

                XCTAssertEqual(expected, actual)
            }
        } else {
            XCTFail("iOS 13, macOS 11.0, tvOS 13 or watchOS 6.0 is required to test SFSafeSymbols.")
        }
    }

    /// Tests whether the `Image` equality check used in the main test works properly
    func testTestMechanism() {
        if #available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *) {
            let expected = Image(systemName: "arrow.clockwise.circle.fill")
            let actual = Image(systemSymbol: .arrowClockwiseCircleFill)
            let wrong = Image(systemSymbol: .arrowClockwiseCircle)

            XCTAssertEqual(expected, actual)
            XCTAssertNotEqual(expected, wrong)
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
