@testable import SFSafeSymbols
import XCTest

#if canImport(SwiftUI)
import SwiftUI
#endif

class ImageExtensionTests: XCTestCase {
    func testSimpleInit() {
        if #available(iOS 13.0, *) {
            SFSymbol.allCases.forEach { symbol in
                // If this doesn't crash, everything works fine
                _ = Image(systemSymbol: symbol)
            }
        } else {
            XCTFail("iOS 13 is required for SFSafeSymbols and SwiftUI.Image.")
        }
    }
}
