@testable import SFSafeSymbols

@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
enum TestHelper {
    static let allSymbolsWithVariants: [SFSymbol] = {
        SFSymbol.allSymbols.flatMap {
            [$0] + $0.availableLocalizations.compactMap($0.localized(to:))
        }.sorted { $0.rawValue < $1.rawValue }
    }()

    static let sampleSymbol: SFSymbol = .arrowClockwiseCircleFill
    static let sampleSymbolWrongDerivate: SFSymbol = .arrowClockwiseCircle

    static let sampleSymbolRawValue: String = "arrow.clockwise.circle.fill"
}
