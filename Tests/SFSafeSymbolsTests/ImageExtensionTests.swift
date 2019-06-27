@testable import SFSafeSymbols

#if !os(watchOS)

import XCTest

#if canImport(SwiftUI)

import SwiftUI

class ImageExtensionTests: XCTestCase {
    func testInit() {
        if #available(iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            SFSymbol.allCases.forEach { symbol in
                // If this doesn't crash, everything works fine
                _ = Image(systemSymbol: symbol)
            }
        } else {
            XCTFail("iOS 13 or tvOS 13 is required to test  SFSafeSymbols.")
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
