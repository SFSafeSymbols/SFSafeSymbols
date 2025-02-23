
@testable import SFSafeSymbols
import XCTest

import AppIntents
#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

class DisplayRepresentationImageTests: XCTestCase {
    /// Tests, whether the `MenuBarExtra` retrieved via SFSafeSymbols can be retrieved without a crash
    func testInit_1() {
        if #available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *) {
            for symbol in TestHelper.allSymbolsWithVariants {
                print("Testing validity of \"\(symbol.rawValue)\" via MenuBarExtra init")

                // If these doesn't crash, everything works fine
                _ = DisplayRepresentation.Image(systemSymbol: symbol, isTemplate: true)

                #if canImport(UIKit)

                _ = DisplayRepresentation.Image(systemSymbol: symbol, tintColor: UIColor.brown, symbolConfiguration: nil)

                #endif

                #if canImport(AppKit) && !targetEnvironment(macCatalyst)

                _ = DisplayRepresentation.Image(systemSymbol: symbol, tintColor: NSColor.brown, symbolConfiguration: nil)

                #endif
            }
        } else {
            print("To test the MenuBarExtra initializer, macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0 is required.")
        }
    }
}
