@testable import SFSafeSymbols

@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
enum TestHelper {
    static let allSymbolsWithVariants: [SFSymbol] = {
        SFSymbol.allLocalizations.flatMap { symbol, localizations in
            [symbol] + localizations.map { symbol.localized(to: $0)! }
        }.sorted { $0.rawValue < $1.rawValue }
    }()

    static let sampleSymbol: SFSymbol = .questionmarkVideoFill
    static let sampleSymbolWrongDerivate: SFSymbol = .questionmarkVideo

    static let sampleSymbolRawValue: String = "questionmark.video.fill"
}
