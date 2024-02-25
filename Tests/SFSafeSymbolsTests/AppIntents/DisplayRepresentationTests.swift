@testable import SFSafeSymbols

import XCTest
import AppIntents

class DisplayRepresentationTests: XCTestCase {
    /// Tests, whether the `DisplayRepresentation.Image` retrieved via SFSafeSymbols is equal to the one retrieved via the `String` initializer
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    func testDisplayRepresentationImage() {
        for symbol in TestHelper.allSymbolsWithVariants {
            print("Testing validity of \"\(symbol.rawValue)\" via DisplayRepresentation.Image init")

            let expected = DisplayRepresentation.Image(systemName: symbol.rawValue)
            let actual = DisplayRepresentation.Image(systemSymbol: symbol)

            XCTAssertEqual(actual, expected)
        }
    }

    /// Tests, whether the `DisplayRepresentation` retrieved via SFSafeSymbols is equal to the one retrieved via the `String` initializer
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    func testDisplayRepresentation() {
        for symbol in TestHelper.allSymbolsWithVariants {
            print("Testing validity of \"\(symbol.rawValue)\" via DisplayRepresentation init")

            let expected = DisplayRepresentation(title: "", image: DisplayRepresentation.Image(systemName: symbol.rawValue))
            let actual = DisplayRepresentation(title: "", systemSymbol: symbol)

            XCTAssertEqual(actual.image, expected.image)
        }
    }
}
