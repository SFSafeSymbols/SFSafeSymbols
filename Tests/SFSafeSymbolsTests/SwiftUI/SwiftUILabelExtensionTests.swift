@testable import SFSafeSymbols

#if !os(watchOS)

import XCTest

#if canImport(SwiftUI)

import SwiftUI

class LabelExtensionTests: XCTestCase {
    /// Tests, whether the `Label` retrieved via SFSafeSymbols can be retrieved without a crash
    func testInit() {
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            for symbol in TestHelper.allSymbolsWithVariants {
                print("Testing validity of \"\(symbol.rawValue)\" via Label init")

                // If this doesn't crash, everything works fine
                _ = Label("Title", systemSymbol: symbol)
            }
        } else {
            print("To test the Label initializer, iOS 14, macOS 11.0 or tvOS 14 is required.")
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
