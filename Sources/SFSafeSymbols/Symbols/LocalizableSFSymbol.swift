
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public protocol SymbolLocalization {
    init(source: SFSymbol)
}

// TODO: replace the following with Variadic Generics once available

@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public /* abstract */ class LocalizableSFSymbol: SFSymbol {
    // MARK: Dynamic Localization
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

// MARK: Static Localization

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

@dynamicMemberLookup
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public class Localizable4Symbol<L1: SymbolLocalization, L2: SymbolLocalization, L3: SymbolLocalization, L4: SymbolLocalization>: LocalizableSFSymbol {
    override var localizations: [SymbolLocalization.Type] { [L1.self, L2.self, L3.self, L4.self] }
    
    subscript(dynamicMember keyPath: KeyPath<L1, SFSymbol>) -> SFSymbol {
        L1(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L2, SFSymbol>) -> SFSymbol {
        L2(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L3, SFSymbol>) -> SFSymbol {
        L3(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L4, SFSymbol>) -> SFSymbol {
        L4(source: self)[keyPath: keyPath]
    }
}

@dynamicMemberLookup
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public class Localizable5Symbol<L1: SymbolLocalization, L2: SymbolLocalization, L3: SymbolLocalization, L4: SymbolLocalization, L5: SymbolLocalization>: LocalizableSFSymbol {
    override var localizations: [SymbolLocalization.Type] { [L1.self, L2.self, L3.self, L4.self, L5.self] }
    
    subscript(dynamicMember keyPath: KeyPath<L1, SFSymbol>) -> SFSymbol {
        L1(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L2, SFSymbol>) -> SFSymbol {
        L2(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L3, SFSymbol>) -> SFSymbol {
        L3(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L4, SFSymbol>) -> SFSymbol {
        L4(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L5, SFSymbol>) -> SFSymbol {
        L5(source: self)[keyPath: keyPath]
    }
}

@dynamicMemberLookup
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public class Localizable6Symbol<L1: SymbolLocalization, L2: SymbolLocalization, L3: SymbolLocalization, L4: SymbolLocalization, L5: SymbolLocalization, L6: SymbolLocalization>: LocalizableSFSymbol {
    override var localizations: [SymbolLocalization.Type] { [L1.self, L2.self, L3.self, L4.self, L5.self, L6.self] }
    
    subscript(dynamicMember keyPath: KeyPath<L1, SFSymbol>) -> SFSymbol {
        L1(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L2, SFSymbol>) -> SFSymbol {
        L2(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L3, SFSymbol>) -> SFSymbol {
        L3(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L4, SFSymbol>) -> SFSymbol {
        L4(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L5, SFSymbol>) -> SFSymbol {
        L5(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L6, SFSymbol>) -> SFSymbol {
        L6(source: self)[keyPath: keyPath]
    }
}

@dynamicMemberLookup
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public class Localizable7Symbol<L1: SymbolLocalization, L2: SymbolLocalization, L3: SymbolLocalization, L4: SymbolLocalization, L5: SymbolLocalization, L6: SymbolLocalization, L7: SymbolLocalization>: LocalizableSFSymbol {
    override var localizations: [SymbolLocalization.Type] { [L1.self, L2.self, L3.self, L4.self, L5.self, L6.self, L7.self] }
    
    subscript(dynamicMember keyPath: KeyPath<L1, SFSymbol>) -> SFSymbol {
        L1(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L2, SFSymbol>) -> SFSymbol {
        L2(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L3, SFSymbol>) -> SFSymbol {
        L3(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L4, SFSymbol>) -> SFSymbol {
        L4(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L5, SFSymbol>) -> SFSymbol {
        L5(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L6, SFSymbol>) -> SFSymbol {
        L6(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L7, SFSymbol>) -> SFSymbol {
        L7(source: self)[keyPath: keyPath]
    }
}

@dynamicMemberLookup
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public class Localizable8Symbol<L1: SymbolLocalization, L2: SymbolLocalization, L3: SymbolLocalization, L4: SymbolLocalization, L5: SymbolLocalization, L6: SymbolLocalization, L7: SymbolLocalization, L8: SymbolLocalization>: LocalizableSFSymbol {
    override var localizations: [SymbolLocalization.Type] { [L1.self, L2.self, L3.self, L4.self, L5.self, L6.self, L7.self, L8.self] }
    
    subscript(dynamicMember keyPath: KeyPath<L1, SFSymbol>) -> SFSymbol {
        L1(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L2, SFSymbol>) -> SFSymbol {
        L2(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L3, SFSymbol>) -> SFSymbol {
        L3(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L4, SFSymbol>) -> SFSymbol {
        L4(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L5, SFSymbol>) -> SFSymbol {
        L5(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L6, SFSymbol>) -> SFSymbol {
        L6(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L7, SFSymbol>) -> SFSymbol {
        L7(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L8, SFSymbol>) -> SFSymbol {
        L8(source: self)[keyPath: keyPath]
    }
}
