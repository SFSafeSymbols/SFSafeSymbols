@testable import SFSafeSymbols

#if !os(watchOS)

import XCTest

#if canImport(SwiftUI)

import SwiftUI

class ImageExtensionTests: XCTestCase {
    func testInitAllSymbols() {
        if #available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *) {
            for symbol in SFSymbol.allSymbols.sorted(by: {$0.rawValue < $1.rawValue}) {
                let expected = Image(systemName: symbol.rawValue)
                let actual = Image(systemSymbol: symbol)
                XCTAssertEqual(expected, actual)
            }
        } else {
            XCTFail("iOS 13, macOS 11.0, tvOS 13 or watchOS 6.0 is required to test SFSafeSymbols.")
        }
    }
    
    func testInitAllSymbols2_2() {
        if #available(iOS 14.5, macOS 11.3, tvOS 14.5, watchOS 7.4, *) {
            for symbol in SFSymbol.allSymbols2_2.sorted(by: {$0.rawValue < $1.rawValue}) {
                let expected = Image(systemName: symbol.rawValue)
                let actual = Image(systemSymbol: symbol)
                XCTAssertEqual(expected, actual)
            }
        } else {
            XCTFail("iOS 14.5, macOS 11.3, tvOS 14.5, watchOS 7.4 is required for this test")
        }
    }
    
    func testInitAllSymbols3_0() {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            for symbol in SFSymbol.allSymbols3_0.sorted(by: {$0.rawValue < $1.rawValue}) {
                let expected = Image(systemName: symbol.rawValue)
                let actual = Image(systemSymbol: symbol)
                XCTAssertEqual(expected, actual)
            }
        } else {
            XCTFail("iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0 is required for this test")
        }
    }
    
    func testInitAllSymbols3_1() {
        if #available(iOS 15.1, macOS 12.0, tvOS 15.1, watchOS 8.1, *) {
            for symbol in SFSymbol.allSymbols3_1.sorted(by: {$0.rawValue < $1.rawValue}) {
                let expected = Image(systemName: symbol.rawValue)
                let actual = Image(systemSymbol: symbol)
                XCTAssertEqual(expected, actual)
            }
        } else {
            XCTFail("iOS 15.1, macOS 12.0, tvOS 15.1, watchOS 8.1 is required for this test")
        }
    }
    
    func testArrowClockwiseCircleFill() {
        if #available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *) {
            let expected = Image(systemSymbol: .arrowClockwiseCircleFill)
            let actual = Image(systemName: "arrow.clockwise.circle.fill")
            XCTAssertEqual(expected, actual)
        }
        else {
            XCTFail("iOS 13, macOS 11.0, tvOS 13 or watchOS 6.0 is required to test SFSafeSymbols.")
        }
    }
    
    func testMismatchArrowClockwiseCircleFill() {
        if #available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *) {
            let expected = Image(systemSymbol: .arrowClockwiseCircleFill)
            let actual = Image(systemName: "arrow.clockwise.circle")
            XCTAssertNotEqual(expected, actual)
        }
        else {
            XCTFail("iOS 13, macOS 11.0, tvOS 13 or watchOS 6.0 is required to test SFSafeSymbols.")
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
