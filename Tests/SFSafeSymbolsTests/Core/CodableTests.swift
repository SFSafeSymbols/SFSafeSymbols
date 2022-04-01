@testable import SFSafeSymbols
import XCTest

@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
class CodableTests: XCTestCase {
    struct SymbolWrapper: Codable {
        let foo: SFSymbol
    }

    func testEncoding() throws {
        let sampleSymbol = TestHelper.sampleSymbol
        print("Testing encoding of \(sampleSymbol.rawValue)")
        let jsonData = #"{"foo":"\#(sampleSymbol.rawValue)"}"#.data(using: .utf8)
        let wrapper = SymbolWrapper(foo: sampleSymbol)
        let encodedData = try JSONEncoder().encode(wrapper)
        XCTAssertEqual(encodedData, jsonData)
    }

    func testDecoding() throws {
        let sampleSymbol = TestHelper.sampleSymbol
        print("Testing decoding of \(sampleSymbol.rawValue)")
        let jsonData = #"{"foo":"\#(sampleSymbol.rawValue)"}"#.data(using: .utf8)
        let symbol = try jsonData.flatMap { try JSONDecoder().decode(SymbolWrapper.self, from: $0) }
        XCTAssertEqual(symbol?.foo, sampleSymbol)
    }
}

@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
extension SFSymbol: Codable { }
