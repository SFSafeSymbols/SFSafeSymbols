@testable import SFSafeSymbols

#if !os(watchOS)

import XCTest

#if canImport(SwiftUI)

import SwiftUI

class LabelExtensionTests: XCTestCase {
    func testInit() {
        if #available(iOS 14.0, OSX 10.16, tvOS 14.0, watchOS 7.0, *) {
            SFSymbol.allSymbols.forEach { symbol in
                // If this doesn't crash, everything works fine
                print("Testing existence of \(symbol.rawValue) via Image init")
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
