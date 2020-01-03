@testable import SFSafeSymbols

#if os(iOS) || targetEnvironment(macCatalyst)

import XCTest

final class UIApplicationShortcutIconExtensionTests: XCTestCase {
    func testSimpleInit() {
        if #available(iOS 13.0, *) {
            SFSymbol.allCases.forEach { symbol in
                // If this doesn't crash, everything works fine
                print("Testing existence of \(symbol.rawValue) via UIApplicationShortcutIcon init")
                _ = UIApplicationShortcutIcon(systemSymbol: symbol)
            }
        } else {
            XCTFail("iOS 13 is required to test SFSafeSymbols.")
        }
    }
}

#endif
