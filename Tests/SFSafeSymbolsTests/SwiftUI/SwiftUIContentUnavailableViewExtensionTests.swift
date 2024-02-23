@testable import SFSafeSymbols

#if !os(watchOS)

import XCTest

#if canImport(SwiftUI)

import SwiftUI

class ContentUnavailableViewExtensionTests: XCTestCase {
    /// Tests, whether the `ContentUnavailableView` retrieved via SFSafeSymbols can be retrieved without a crash
    func testInit() {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            for symbol in TestHelper.allSymbolsWithVariants {
                print("Testing validity of \"\(symbol.rawValue)\" via ContentUnavailableView init")

                // If this doesn't crash, everything works fine
                _ = ContentUnavailableView("Title", systemSymbol: symbol, description: .init(verbatim: "Description"))
            }
        } else {
            print("To test the ContentUnavailableView initializer, iOS 17, macOS 14.0 or tvOS 17 is required.")
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

