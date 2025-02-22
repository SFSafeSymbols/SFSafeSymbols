#if canImport(SwiftUI)

@testable import SFSafeSymbols
import XCTest
import SwiftUI

class ContentUnavailableViewExtensionTests: XCTestCase {
    /// Tests, whether the `ContentUnavailableView` retrieved via SFSafeSymbols can be retrieved without a crash
    func testInit() {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *) {
            for symbol in TestHelper.allSymbolsWithVariants {
                print("Testing validity of \"\(symbol.rawValue)\" via ContentUnavailableView init")

                // If these doesn't crash, everything works fine
                _ = ContentUnavailableView("Title" as LocalizedStringKey, systemSymbol: symbol)
                _ = ContentUnavailableView("Title" as String, systemSymbol: symbol)
            }
        } else {
            print("To test the ContentUnavailableView initializer, iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0 or visionOS 1.0 is required.")
        }
    }
}

#endif
