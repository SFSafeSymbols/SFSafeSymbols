@testable import SFSafeSymbols

@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
enum TestHelper {
    static let allSymbols: [SFSymbol] = {
        SFSymbol.allSymbols.sorted { $0.rawValue < $1.rawValue }
    }()

    static let sampleSymbol: SFSymbol = .arrowClockwiseCircleFill
    static let sampleSymbolWrongDerivate: SFSymbol = .arrowClockwiseCircle

    static let sampleSymbolRawValue: String = "arrow.clockwise.circle.fill"
}
