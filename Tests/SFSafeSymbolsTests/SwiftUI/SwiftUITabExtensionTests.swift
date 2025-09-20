#if canImport(SwiftUI)

import SwiftUI
import XCTest
@testable import SFSafeSymbols

class TabExtensionTests: XCTestCase {
    /// Tests, whether the `Tab` retrieved via SFSafeSymbols can be retrieved without a crash
    func testInit() {
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            for symbol in TestHelper.allSymbolsWithVariants {
                print("Testing validity of \"\(symbol.rawValue)\" via Tab init")

                // Test Tab initializers with Value parameter
                // If this doesn't crash, everything works fine
                let title: String = "Test"
                _ = Tab(title, systemSymbol: symbol, value: 1) { Text("Content") }
                
                let localizedStringKey: LocalizedStringKey = "Test"
                _ = Tab(localizedStringKey, systemSymbol: symbol, value: 2) { Text("Content") }
                
                // Test Tab initializers without Value parameter
                _ = Tab(title, systemSymbol: symbol) { Text("Content") }
                _ = Tab(localizedStringKey, systemSymbol: symbol) { Text("Content") }
                
                // Test with LocalizedStringResource if available
                if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
                    let titleResource = LocalizedStringResource("Test")
                    _ = Tab(titleResource, systemSymbol: symbol, value: 3) { Text("Content") }
                    _ = Tab(titleResource, systemSymbol: symbol) { Text("Content") }
                }
            }
        } else {
            print("To test the Tab initializer, iOS 18, macOS 15.0, tvOS 18, watchOS 11, or visionOS 2.0 is required.")
        }
    }
}

#else

class JustFail: XCTestCase {
    func test_justFail() {
        XCTFail("SwiftUI should be available when testing.")
    }
}

#endif
