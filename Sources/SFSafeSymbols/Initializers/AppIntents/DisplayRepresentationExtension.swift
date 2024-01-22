import AppIntents

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension DisplayRepresentation {
    init(title: LocalizedStringResource, subtitle: LocalizedStringResource? = nil, systemSymbol: SFSymbol? = nil) {
        self.init(
            title: title,
            subtitle: subtitle,
            image: systemSymbol.map { DisplayRepresentation.Image(systemSymbol: $0) }
        )
    }

    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    init(title: LocalizedStringResource, subtitle: LocalizedStringResource? = nil, systemSymbol: SFSymbol? = nil, synonyms: [LocalizedStringResource] = []) {
        self.init(
            title: title,
            subtitle: subtitle,
            image: systemSymbol.map { DisplayRepresentation.Image(systemSymbol: $0) },
            synonyms: synonyms
        )
    }
}
