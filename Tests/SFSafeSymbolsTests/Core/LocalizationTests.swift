@testable import SFSafeSymbols
import XCTest

@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
class LocalizationTests: XCTestCase {
    func testLocalizationsFromRawValue() throws {
        let rawValue = TestHelper.sampleSymbolRawValue
        let localizationsBefore = SFSymbol.allLocalizations[TestHelper.sampleSymbol]!
        let localizationsAfter = SFSymbol.allLocalizations[SFSymbol(rawValue: rawValue)]!
        XCTAssertEqual(localizationsBefore, localizationsAfter)
    }
}
