@testable import SFSafeSymbols

#if os(macOS)

import XCTest

class NSImageExtensionTests: XCTestCase {
    func testSimpleInit() {
        if #available(macOS 11.0, *) {
            SFSymbol.allCases.forEach { symbol in
                // If this doesn't crash, everything works fine
                print("Testing existence of \(symbol.rawValue) via NSImage init")
                _ = NSImage(systemSymbol: symbol)
            }
        } else {
            XCTFail("macOS 11 is required to test SFSafeSymbols.")
        }
    }
}

#endif
