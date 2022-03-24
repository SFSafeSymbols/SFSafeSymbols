
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public protocol SymbolLocalization {
    init(source: SFSymbol)
}

// TODO: replace the following with Variadic Generics once available
// Since the code is currently only an interim solution, we don't auto-generate it.
// Beware: if more localizations are added to SFSymbols before variadic generics are introduced to Swift, you may have to create the missing specialized classes.

@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public /* abstract */ class LocalizableSFSymbol: SFSymbol {
    // MARK: Dynamic Localization
    internal var localizations: [SymbolLocalization.Type] { fatalError("abstract method, override") }

    /// Determine all localizations `self` can be localized to on the current platform.
    public lazy var availableLocalizations = { _availableLocalizations }()

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
public class NonLocalizedSymbol: LocalizableSFSymbol {
    override var localizations: [SymbolLocalization.Type] { [] }
}

@dynamicMemberLookup
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public class SymbolWith1Localization<L1: SymbolLocalization>: LocalizableSFSymbol {
    override var localizations: [SymbolLocalization.Type] { [L1.self] }
    
    subscript(dynamicMember keyPath: KeyPath<L1, SFSymbol>) -> SFSymbol {
        L1(source: self)[keyPath: keyPath]
    }
}

@dynamicMemberLookup
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public class SymbolWith2Localizations<L1: SymbolLocalization, L2: SymbolLocalization>: LocalizableSFSymbol {
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
public class SymbolWith3Localizations<L1: SymbolLocalization, L2: SymbolLocalization, L3: SymbolLocalization>: LocalizableSFSymbol {
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
public class SymbolWith4Localizations<L1: SymbolLocalization, L2: SymbolLocalization, L3: SymbolLocalization, L4: SymbolLocalization>: LocalizableSFSymbol {
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
public class SymbolWith5Localizations<L1: SymbolLocalization, L2: SymbolLocalization, L3: SymbolLocalization, L4: SymbolLocalization, L5: SymbolLocalization>: LocalizableSFSymbol {
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
public class SymbolWith6Localizations<L1: SymbolLocalization, L2: SymbolLocalization, L3: SymbolLocalization, L4: SymbolLocalization, L5: SymbolLocalization, L6: SymbolLocalization>: LocalizableSFSymbol {
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
public class SymbolWith7Localizations<L1: SymbolLocalization, L2: SymbolLocalization, L3: SymbolLocalization, L4: SymbolLocalization, L5: SymbolLocalization, L6: SymbolLocalization, L7: SymbolLocalization>: LocalizableSFSymbol {
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
public class SymbolWith8Localizations<L1: SymbolLocalization, L2: SymbolLocalization, L3: SymbolLocalization, L4: SymbolLocalization, L5: SymbolLocalization, L6: SymbolLocalization, L7: SymbolLocalization, L8: SymbolLocalization>: LocalizableSFSymbol {
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
