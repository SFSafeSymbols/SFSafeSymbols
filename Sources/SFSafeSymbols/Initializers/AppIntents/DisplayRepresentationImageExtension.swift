import AppIntents

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension DisplayRepresentation.Image {
    init(systemSymbol: SFSymbol) {
        self.init(systemName: systemSymbol.rawValue)
    }
}
