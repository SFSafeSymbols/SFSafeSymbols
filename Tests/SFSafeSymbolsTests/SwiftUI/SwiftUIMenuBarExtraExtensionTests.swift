#if canImport(SwiftUI) && os(macOS) && !targetEnvironment(macCatalyst)

@testable import SFSafeSymbols
import XCTest
import SwiftUI

class MenuBarExtraExtensionTests: XCTestCase {
    /// Tests, whether the `MenuBarExtra` retrieved via SFSafeSymbols can be retrieved without a crash
    func testInit() {
        if #available(macOS 13.0, *) {
            for symbol in TestHelper.allSymbolsWithVariants {
                print("Testing validity of \"\(symbol.rawValue)\" via MenuBarExtra init")

                // If these doesn't crash, everything works fine
                _ = MenuBarExtra("Title" as LocalizedStringKey, systemSymbol: symbol, isInserted: .constant(true)) {
                    Text("Content")
                }
                _ = MenuBarExtra("Title" as String, systemSymbol: symbol, isInserted: .constant(true)) {
                    Text("Content")
                }
                _ = MenuBarExtra("Title" as LocalizedStringKey, systemSymbol: symbol) {
                    Text("Content")
                }
                _ = MenuBarExtra("Title" as String, systemSymbol: symbol) {
                    Text("Content")
                }
            }
        } else {
            print("To test the MenuBarExtra initializer, macOS 13.0 is required.")
        }
    }
}

#endif
