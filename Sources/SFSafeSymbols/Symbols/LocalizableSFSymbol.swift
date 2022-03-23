
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public protocol SymbolLocalization {
    init(source: SFSymbol)
}

// TODO: replace the following with Variadic Generics once available

@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public /* abstract */ class LocalizableSFSymbol: SFSymbol {
    internal var localizations: [SymbolLocalization.Type] { fatalError("abstract method, override") }
    
    /// Determine whether `self` can be localized to `localization` on the current platform.
    public func has(localization: Localization) -> Bool {
        availableLocalizations.contains(localization)
    }
    
    /// If `self` is localizable to `localization`, localize it, otherwise return `nil`.
    public func localized(to localization: Localization) -> SFSymbol? {
        if has(localization: localization) {
            return SFSymbol(rawValue: "\(rawValue).\(localization.rawValue)")
        } else {
            return nil
        }
    }
}


@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public class Localizable0Symbol: LocalizableSFSymbol {
    override var localizations: [SymbolLocalization.Type] { [] }
}

@dynamicMemberLookup
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public class Localizable1Symbol<L1: SymbolLocalization>: LocalizableSFSymbol {
    override var localizations: [SymbolLocalization.Type] { [L1.self] }
    
    subscript(dynamicMember keyPath: KeyPath<L1, SFSymbol>) -> SFSymbol {
        L1(source: self)[keyPath: keyPath]
    }
}

@dynamicMemberLookup
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public class Localizable2Symbol<L1: SymbolLocalization, L2: SymbolLocalization>: LocalizableSFSymbol {
    override var localizations: [SymbolLocalization.Type] { [L1.self, L2.self] }
    
    subscript(dynamicMember keyPath: KeyPath<L1, SFSymbol>) -> SFSymbol {
        L1(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L2, SFSymbol>) -> SFSymbol {
        L2(source: self)[keyPath: keyPath]
    }
}

@dynamicMemberLookup
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public class Localizable3Symbol<L1: SymbolLocalization, L2: SymbolLocalization, L3: SymbolLocalization>: LocalizableSFSymbol {
    override var localizations: [SymbolLocalization.Type] { [L1.self, L2.self, L3.self] }
    
    subscript(dynamicMember keyPath: KeyPath<L1, SFSymbol>) -> SFSymbol {
        L1(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L2, SFSymbol>) -> SFSymbol {
        L2(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L3, SFSymbol>) -> SFSymbol {
        L3(source: self)[keyPath: keyPath]
    }
}

// Localizable4Symbol
// Localizable5Symbol
// Localizable6Symbol
// Localizable7Symbol
// Localizable8Symbol
