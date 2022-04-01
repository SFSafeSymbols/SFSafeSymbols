@testable import SFSafeSymbols

#if (os(iOS) || os(tvOS) || targetEnvironment(macCatalyst))

import XCTest

class UIButtonExtensionTests: XCTestCase {
    /// Tests, whether the custom `UIButton` initializer works as expected
    func testInit() {
        if #available(iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            let symbol = TestHelper.sampleSymbol
            let button = UIButton.systemButton(with: symbol, target: nil, action: nil)

            let expected = UIImage(systemSymbol: symbol)
            let actual = button.currentImage
            
            XCTAssertEqual(actual, expected)
        } else {
            XCTFail("iOS 13, tvOS 13 or watchOS 6.0 is required to test SFSafeSymbols.")
        }
    }

    /// Tests, whether the custom `UIButton` `setImage` method works as expected
    func testSetImage() {
        if #available(iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            let symbol = TestHelper.sampleSymbol
            let button = UIButton()

            let expected = UIImage(systemSymbol: symbol)
            button.setImage(symbol, for: .normal)
            let actual = button.currentImage

            XCTAssertEqual(actual, expected)
        } else {
            XCTFail("iOS 13, tvOS 13 or watchOS 6.0 is required to test SFSafeSymbols.")
        }
    }
}

#endif
