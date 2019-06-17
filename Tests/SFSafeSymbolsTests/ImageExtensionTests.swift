@testable import SFSafeSymbols
import XCTest

#if canImport(SwiftUI)
import SwiftUI

class ImageExtensionTests: XCTestCase {
    func testSimpleInit() {
        SFSymbol.allCases.forEach { symbol in
            // If this doesn't crash, everything works fine
            _ = Image(systemSymbol: symbol)
        }
    }
}
#endif
