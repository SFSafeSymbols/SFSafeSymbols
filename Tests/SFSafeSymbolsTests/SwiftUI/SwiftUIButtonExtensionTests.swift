@testable import SFSafeSymbols

#if !os(watchOS)

import XCTest

#if canImport(SwiftUI)

import SwiftUI
import AppIntents


class ButtonExtensionTests: XCTestCase {
    /// Tests, whether the `Label` retrieved via SFSafeSymbols can be retrieved without a crash
    func testInit() {
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            print("Testing validity of symbols via Button init")

            for symbol in TestHelper.allSymbolsWithVariants {

                // If this doesn't crash, everything works fine
                let title: String = ""
                _ = Button(title, systemSymbol: symbol) {}
                
                let localizedStringKey: LocalizedStringKey = ""
                _ = Button(localizedStringKey, systemSymbol: symbol) {}
                
                if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *) {
                    let title: String = ""
                    _ = Button(title, systemSymbol: symbol, role: .cancel) {}
                    
                    let localizedStringKey: LocalizedStringKey = ""
                    _ = Button(localizedStringKey, systemSymbol: symbol, role: .cancel) {}
                }
            }
        } else {
            print("To test the Button initializer, iOS 14, macOS 11.0 or tvOS 14 is required.")
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
