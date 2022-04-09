@testable import SFSafeSymbols

#if !os(watchOS) && !os(macOS)

import XCTest

class UIImageExtensionTests: XCTestCase {
    /// Tests, whether a non-nil`UIImage` exists for all symbol raw values
    /// Symbols for which such an `UIImage` doesn't exist, will be logged to facilitate debugging
    func testFailingSymbols() {
        if #available(iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            let failingSymbols = TestHelper.allSymbolsWithVariants.map { $0.rawValue }.map { ($0, UIImage(systemName: $0)) }.filter { $0.1 == nil }.map { $0.0 }

            if !failingSymbols.isEmpty {
                print("The following symbols are failing: \(failingSymbols)")
                XCTFail("There should be no failing symbols.")
            }
        } else {
            XCTFail("iOS 13, tvOS 13 or watchOS 6.0 is required to test SFSafeSymbols.")
        }
    }

    /// Tests, whether the `UIImage` retrieved via SFSafeSymbols is equal to the one retrieved via the `String` initializer
    func testInit() {
        if #available(iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            for symbol in TestHelper.allSymbolsWithVariants {
                print("Testing validity of \"\(symbol.rawValue)\" via UIImage init")

                let expected = UIImage(systemName: symbol.rawValue)
                let actual = UIImage(systemSymbol: symbol)

                XCTAssertEqual(actual, expected)
            }
        } else {
            XCTFail("iOS 13, tvOS 13 or watchOS 6.0 is required to test SFSafeSymbols.")
        }
    }

    /// Tests, whether the `UIImage` retrieved via SFSafeSymbols is equal to the one retrieved via the `String` initializer,
    /// even when passing a configuration
    func testInitWithConfiguration() {
        if #available(iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            // Get some configurations
            let configurations: [UIImage.Configuration] = [
                UIImage.SymbolConfiguration(pointSize: 10),
                UIImage.SymbolConfiguration(scale: .medium),
                UIImage.SymbolConfiguration(pointSize: 10, weight: .bold, scale: .small),
                UITraitCollection(verticalSizeClass: .regular).imageConfiguration,
                UITraitCollection(legibilityWeight: .bold).imageConfiguration
            ]

            // Go over cross product: symbols x configs
            for symbol in TestHelper.allSymbolsWithVariants {
                for configuration in configurations {
                    print("Testing validity of \"\(symbol.rawValue)\" with configuration \"\(configuration)\" via UIImage init")

                    let expected = UIImage(systemName: symbol.rawValue, withConfiguration: configuration)
                    let actual = UIImage(systemSymbol: symbol, withConfiguration: configuration)

                    XCTAssertEqual(actual, expected)
                }
            }
        } else {
            XCTFail("iOS 13, tvOS 13 or watchOS 6.0 is required to test SFSafeSymbols.")
        }
    }

    /// Tests whether the `UIImage` equality check used in the main test works properly
    func testTestMechanism() {
        if #available(iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            let expected = UIImage(systemName: TestHelper.sampleSymbolRawValue)
            let actual = UIImage(systemSymbol: TestHelper.sampleSymbol)
            let wrong = UIImage(systemSymbol: TestHelper.sampleSymbolWrongDerivate)

            XCTAssertEqual(actual, expected)
            XCTAssertNotEqual(wrong, expected)
        }
        else {
            XCTFail("iOS 13, tvOS 13 or watchOS 6.0 is required to test SFSafeSymbols.")
        }
    }
}

#endif
