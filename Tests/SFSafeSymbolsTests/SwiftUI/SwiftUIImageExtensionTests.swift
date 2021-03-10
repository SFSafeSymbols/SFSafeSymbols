@testable import SFSafeSymbols

#if !os(watchOS)

import XCTest

#if canImport(SwiftUI)

import SwiftUI

class ImageExtensionTests: XCTestCase {
    func testInit() {
        if #available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *) {
            SFSymbol.allCases.forEach { symbol in
                // If this doesn't crash, everything works fine
                print("Testing existence of \(symbol.rawValue) via Image init")
                _ = Image(systemSymbol: symbol)
            }
        } else {
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
