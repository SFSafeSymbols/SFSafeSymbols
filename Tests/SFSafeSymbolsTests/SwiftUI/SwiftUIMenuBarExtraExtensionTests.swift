@testable import SFSafeSymbols

#if !os(watchOS)

import XCTest

#if canImport(SwiftUI)

import SwiftUI

class MenuBarExtraExtensionTests: XCTestCase {
    /// Tests, whether the `MenuBarExtra` retrieved via SFSafeSymbols can be retrieved without a crash
    func testInit() {
        if #available(macOS 13.0, *) {
            for symbol in TestHelper.allSymbolsWithVariants {
                print("Testing validity of \"\(symbol.rawValue)\" via MenuBarExtra init")

                // If this doesn't crash, everything works fine
                _ = MenuBarExtra("Title", systemSymbol: symbol, isInserted: .constant(true)) {
                    Text("Content")
                }
            }
        } else {
            print("To test the MenuBarExtra initializer, macOS 13.0 is required.")
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


