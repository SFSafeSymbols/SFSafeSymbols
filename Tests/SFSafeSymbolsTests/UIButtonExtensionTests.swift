@testable import SFSafeSymbols

#if !os(watchOS) && !os(macOS)
import XCTest

class UIButtonExtensionTests: XCTestCase {

    func testButtonInit() {
        if #available(iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            SFSymbol.allCases.forEach { symbol in
                print("Testing UIButton init with \(symbol.rawValue)")
                let button = UIButton.systemButton(with: symbol, target: nil, action: nil)
                XCTAssertEqual(button.currentImage, UIImage(systemSymbol: symbol))
            }
        } else {
            XCTFail("iOS 13 or tvOS 13 is required to test  SFSafeSymbols.")
        }
    }
    
    func testSetImage() {
        if #available(iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            SFSymbol.allCases.forEach { symbol in
                print("Testing UIButton setImage with \(symbol.rawValue)")
                let button = UIButton()
                let symbolImage = UIImage(systemSymbol: symbol)
                button.setImage(symbolImage, for: .normal)
                XCTAssertEqual(button.image(for: .normal), symbolImage)
            }
        } else {
            XCTFail("iOS 13 or tvOS 13 is required to test  SFSafeSymbols.")
        }
    }
}

#endif
