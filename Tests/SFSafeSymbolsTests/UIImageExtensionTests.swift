#if os(iOS) || os(tvOS) || os(watchOS)

@testable import SFSafeSymbols
import XCTest

class UIImageExtensionTests: XCTestCase {
    func testSimpleInit() {
        SFSymbol.allCases.forEach {
            // If this doesn't crash, everything works fine
            let _ = UIImage(systemSymbol: $0)
        }
    }

    func testInitWithConfiguration() {
        // TODO: Test with configuration
        SFSymbol.allCases.forEach {
            // If this doesn't crash, everything works fine
            let _ = UIImage(systemSymbol: $0)
        }
    }

    func testInitWithTraits() {
        // TODO: Test with traits
        SFSymbol.allCases.forEach {
            // If this doesn't crash, everything works fine
            let _ = UIImage(systemSymbol: $0)
        }
    }
}

#endif
