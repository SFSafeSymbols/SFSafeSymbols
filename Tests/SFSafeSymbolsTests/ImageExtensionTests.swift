@testable import SFSafeSymbols
import XCTest
import SwiftUI

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
    
    func testInitWithConfiguration() {
        if #available(iOS 13.0, *) {
            let configurations = [
                UITraitCollection(forceTouchCapability: .available),
                UITraitCollection(horizontalSizeClass: .compact),
                UITraitCollection(horizontalSizeClass: .regular),
                UITraitCollection(verticalSizeClass: .compact),
                UITraitCollection(verticalSizeClass: .unspecified),
                UITraitCollection(legibilityWeight: .bold),
                UITraitCollection(legibilityWeight: .regular),
                UITraitCollection(legibilityWeight: .unspecified),
                ].map { $0.imageConfiguration }
            
            SFSymbol.allCases.forEach { symbol in
                configurations.forEach { configuration in
                    // If this doesn't crash, everything works fine
                    _ = Image(systemSymbol: symbol, withConfiguration: configuration)
                }
            }
        } else {
            XCTFail("iOS 13 is required for SFSafeSymbols and SwiftUI.Image.")
        }
    }
    
    func testInitWithTraits() {
        if #available(iOS 13.0, *) {
            let traits = [
                UITraitCollection(forceTouchCapability: .available),
                UITraitCollection(horizontalSizeClass: .compact),
                UITraitCollection(horizontalSizeClass: .regular),
                UITraitCollection(verticalSizeClass: .compact),
                UITraitCollection(verticalSizeClass: .unspecified),
                UITraitCollection(legibilityWeight: .bold),
                UITraitCollection(legibilityWeight: .regular),
                UITraitCollection(legibilityWeight: .unspecified),
            ]
            
            SFSymbol.allCases.forEach { symbol in
                traits.forEach { trait in
                    // If this doesn't crash, everything works fine
                    _ = Image(systemSymbol: symbol, compatibleWith: trait)
                }
            }
        } else {
            XCTFail("iOS 13 is required for SFSafeSymbols and SwiftUI.Image.")
        }
    }
}
