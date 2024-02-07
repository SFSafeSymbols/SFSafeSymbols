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
            for symbol in TestHelper.allSymbolsWithVariants {
                print("Testing validity of \"\(symbol.rawValue)\" via Label init")

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
                
                if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                    let title: String = ""
                    _ = Button(title, systemSymbol: symbol, role: .cancel, intent: OrderSoupIntent())
                    
                    let localizedStringKey: LocalizedStringKey = ""
                    _ = Button(localizedStringKey, systemSymbol: symbol, role: .cancel, intent: OrderSoupIntent())
                }
            }
        } else {
            print("To test the Button initializer, iOS 14, macOS 11.0 or tvOS 14 is required.")
        }
    }
    
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    struct OrderSoupIntent: AppIntent {
        static var title = LocalizedStringResource("Order Soup")
        static var description = IntentDescription("Orders a soup from your favorite restaurant.")
        
        init() { }
        
        func perform() async throws -> some IntentResult {
            return .result()
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
