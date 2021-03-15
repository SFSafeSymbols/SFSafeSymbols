import XCTest
import SFSafeSymbols

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
class SFSymbolTests: XCTestCase {
    
    func testInitializer() {
        let symbol = SFSymbol(rawValue: "0.circle")
        XCTAssertNotNil(symbol)
    }
}
