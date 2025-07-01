
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
public protocol SymbolLocalization: Sendable {
    init(source: SFSymbol)
}

// TODO: replace the following with Variadic Generics once available
// Since the code is currently only an interim solution, we don't auto-generate it.
// Beware: if more localizations are added to SFSymbols before variadic generics are introduced to Swift, you may have to create the missing specialized classes.

// MARK: Static Localization

@dynamicMemberLookup
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
public class SymbolWith1Localization<L1: SymbolLocalization>: SFSymbol, @unchecked Sendable {
    subscript(dynamicMember keyPath: KeyPath<L1, SFSymbol>) -> SFSymbol {
        L1(source: self)[keyPath: keyPath]
    }
}

@dynamicMemberLookup
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
public class SymbolWith2Localizations<L1: SymbolLocalization, L2: SymbolLocalization>: SFSymbol, @unchecked Sendable {
    subscript(dynamicMember keyPath: KeyPath<L1, SFSymbol>) -> SFSymbol {
        L1(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L2, SFSymbol>) -> SFSymbol {
        L2(source: self)[keyPath: keyPath]
    }
}

@dynamicMemberLookup
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
public class SymbolWith3Localizations<L1: SymbolLocalization, L2: SymbolLocalization, L3: SymbolLocalization>: SFSymbol, @unchecked Sendable {
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
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
public class SymbolWith4Localizations<L1: SymbolLocalization, L2: SymbolLocalization, L3: SymbolLocalization, L4: SymbolLocalization>: SFSymbol, @unchecked Sendable {
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
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
public class SymbolWith5Localizations<L1: SymbolLocalization, L2: SymbolLocalization, L3: SymbolLocalization, L4: SymbolLocalization, L5: SymbolLocalization>: SFSymbol, @unchecked Sendable {
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
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
public class SymbolWith6Localizations<L1: SymbolLocalization, L2: SymbolLocalization, L3: SymbolLocalization, L4: SymbolLocalization, L5: SymbolLocalization, L6: SymbolLocalization>: SFSymbol, @unchecked Sendable {
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
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
public class SymbolWith7Localizations<L1: SymbolLocalization, L2: SymbolLocalization, L3: SymbolLocalization, L4: SymbolLocalization, L5: SymbolLocalization, L6: SymbolLocalization, L7: SymbolLocalization>: SFSymbol, @unchecked Sendable {
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
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
public class SymbolWith8Localizations<L1: SymbolLocalization, L2: SymbolLocalization, L3: SymbolLocalization, L4: SymbolLocalization, L5: SymbolLocalization, L6: SymbolLocalization, L7: SymbolLocalization, L8: SymbolLocalization>: SFSymbol, @unchecked Sendable {
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

@dynamicMemberLookup
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
public class SymbolWith9Localizations<L1: SymbolLocalization, L2: SymbolLocalization, L3: SymbolLocalization, L4: SymbolLocalization, L5: SymbolLocalization, L6: SymbolLocalization, L7: SymbolLocalization, L8: SymbolLocalization, L9: SymbolLocalization>: SFSymbol, @unchecked Sendable {
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
    subscript(dynamicMember keyPath: KeyPath<L9, SFSymbol>) -> SFSymbol {
        L9(source: self)[keyPath: keyPath]
    }
}

@dynamicMemberLookup
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
public class SymbolWith13Localizations<L1: SymbolLocalization, L2: SymbolLocalization, L3: SymbolLocalization, L4: SymbolLocalization, L5: SymbolLocalization, L6: SymbolLocalization, L7: SymbolLocalization, L8: SymbolLocalization, L9: SymbolLocalization, L10: SymbolLocalization, L11: SymbolLocalization, L12: SymbolLocalization, L13: SymbolLocalization
>: SFSymbol, @unchecked Sendable {
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
    subscript(dynamicMember keyPath: KeyPath<L9, SFSymbol>) -> SFSymbol {
        L9(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L10, SFSymbol>) -> SFSymbol {
        L10(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L11, SFSymbol>) -> SFSymbol {
        L11(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L12, SFSymbol>) -> SFSymbol {
        L12(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L13, SFSymbol>) -> SFSymbol {
        L13(source: self)[keyPath: keyPath]
    }
}

@dynamicMemberLookup
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
public class SymbolWith14Localizations<L1: SymbolLocalization, L2: SymbolLocalization, L3: SymbolLocalization, L4: SymbolLocalization, L5: SymbolLocalization, L6: SymbolLocalization, L7: SymbolLocalization, L8: SymbolLocalization, L9: SymbolLocalization, L10: SymbolLocalization, L11: SymbolLocalization, L12: SymbolLocalization, L13: SymbolLocalization, L14: SymbolLocalization
>: SFSymbol, @unchecked Sendable {
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
    subscript(dynamicMember keyPath: KeyPath<L9, SFSymbol>) -> SFSymbol {
        L9(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L10, SFSymbol>) -> SFSymbol {
        L10(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L11, SFSymbol>) -> SFSymbol {
        L11(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L12, SFSymbol>) -> SFSymbol {
        L12(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L13, SFSymbol>) -> SFSymbol {
        L13(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L14, SFSymbol>) -> SFSymbol {
        L14(source: self)[keyPath: keyPath]
    }
}

@dynamicMemberLookup
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
public class SymbolWith18Localizations<L1: SymbolLocalization, L2: SymbolLocalization, L3: SymbolLocalization, L4: SymbolLocalization, L5: SymbolLocalization, L6: SymbolLocalization, L7: SymbolLocalization, L8: SymbolLocalization, L9: SymbolLocalization, L10: SymbolLocalization, L11: SymbolLocalization, L12: SymbolLocalization, L13: SymbolLocalization, L14: SymbolLocalization, L15: SymbolLocalization, L16: SymbolLocalization, L17: SymbolLocalization, L18: SymbolLocalization
>: SFSymbol, @unchecked Sendable {
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
    subscript(dynamicMember keyPath: KeyPath<L9, SFSymbol>) -> SFSymbol {
        L9(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L10, SFSymbol>) -> SFSymbol {
        L10(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L11, SFSymbol>) -> SFSymbol {
        L11(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L12, SFSymbol>) -> SFSymbol {
        L12(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L13, SFSymbol>) -> SFSymbol {
        L13(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L14, SFSymbol>) -> SFSymbol {
        L14(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L15, SFSymbol>) -> SFSymbol {
        L15(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L16, SFSymbol>) -> SFSymbol {
        L16(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L17, SFSymbol>) -> SFSymbol {
        L17(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L18, SFSymbol>) -> SFSymbol {
        L18(source: self)[keyPath: keyPath]
    }
}

@dynamicMemberLookup
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
public class SymbolWith19Localizations<L1: SymbolLocalization, L2: SymbolLocalization, L3: SymbolLocalization, L4: SymbolLocalization, L5: SymbolLocalization, L6: SymbolLocalization, L7: SymbolLocalization, L8: SymbolLocalization, L9: SymbolLocalization, L10: SymbolLocalization, L11: SymbolLocalization, L12: SymbolLocalization, L13: SymbolLocalization, L14: SymbolLocalization, L15: SymbolLocalization, L16: SymbolLocalization, L17: SymbolLocalization, L18: SymbolLocalization, L19: SymbolLocalization
>: SFSymbol, @unchecked Sendable {
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
    subscript(dynamicMember keyPath: KeyPath<L9, SFSymbol>) -> SFSymbol {
        L9(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L10, SFSymbol>) -> SFSymbol {
        L10(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L11, SFSymbol>) -> SFSymbol {
        L11(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L12, SFSymbol>) -> SFSymbol {
        L12(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L13, SFSymbol>) -> SFSymbol {
        L13(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L14, SFSymbol>) -> SFSymbol {
        L14(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L15, SFSymbol>) -> SFSymbol {
        L15(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L16, SFSymbol>) -> SFSymbol {
        L16(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L17, SFSymbol>) -> SFSymbol {
        L17(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L18, SFSymbol>) -> SFSymbol {
        L18(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L19, SFSymbol>) -> SFSymbol {
        L19(source: self)[keyPath: keyPath]
    }
}

@dynamicMemberLookup
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
public class SymbolWith20Localizations<L1: SymbolLocalization, L2: SymbolLocalization, L3: SymbolLocalization, L4: SymbolLocalization, L5: SymbolLocalization, L6: SymbolLocalization, L7: SymbolLocalization, L8: SymbolLocalization, L9: SymbolLocalization, L10: SymbolLocalization, L11: SymbolLocalization, L12: SymbolLocalization, L13: SymbolLocalization, L14: SymbolLocalization, L15: SymbolLocalization, L16: SymbolLocalization, L17: SymbolLocalization, L18: SymbolLocalization, L19: SymbolLocalization, L20: SymbolLocalization
>: SFSymbol, @unchecked Sendable {
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
    subscript(dynamicMember keyPath: KeyPath<L9, SFSymbol>) -> SFSymbol {
        L9(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L10, SFSymbol>) -> SFSymbol {
        L10(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L11, SFSymbol>) -> SFSymbol {
        L11(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L12, SFSymbol>) -> SFSymbol {
        L12(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L13, SFSymbol>) -> SFSymbol {
        L13(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L14, SFSymbol>) -> SFSymbol {
        L14(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L15, SFSymbol>) -> SFSymbol {
        L15(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L16, SFSymbol>) -> SFSymbol {
        L16(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L17, SFSymbol>) -> SFSymbol {
        L17(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L18, SFSymbol>) -> SFSymbol {
        L18(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L19, SFSymbol>) -> SFSymbol {
        L19(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L20, SFSymbol>) -> SFSymbol {
        L20(source: self)[keyPath: keyPath]
    }
}

@dynamicMemberLookup
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
public class SymbolWith21Localizations<L1: SymbolLocalization, L2: SymbolLocalization, L3: SymbolLocalization, L4: SymbolLocalization, L5: SymbolLocalization, L6: SymbolLocalization, L7: SymbolLocalization, L8: SymbolLocalization, L9: SymbolLocalization, L10: SymbolLocalization, L11: SymbolLocalization, L12: SymbolLocalization, L13: SymbolLocalization, L14: SymbolLocalization, L15: SymbolLocalization, L16: SymbolLocalization, L17: SymbolLocalization, L18: SymbolLocalization, L19: SymbolLocalization, L20: SymbolLocalization, L21: SymbolLocalization
>: SFSymbol, @unchecked Sendable {
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
    subscript(dynamicMember keyPath: KeyPath<L9, SFSymbol>) -> SFSymbol {
        L9(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L10, SFSymbol>) -> SFSymbol {
        L10(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L11, SFSymbol>) -> SFSymbol {
        L11(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L12, SFSymbol>) -> SFSymbol {
        L12(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L13, SFSymbol>) -> SFSymbol {
        L13(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L14, SFSymbol>) -> SFSymbol {
        L14(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L15, SFSymbol>) -> SFSymbol {
        L15(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L16, SFSymbol>) -> SFSymbol {
        L16(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L17, SFSymbol>) -> SFSymbol {
        L17(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L18, SFSymbol>) -> SFSymbol {
        L18(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L19, SFSymbol>) -> SFSymbol {
        L19(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L20, SFSymbol>) -> SFSymbol {
        L20(source: self)[keyPath: keyPath]
    }
    subscript(dynamicMember keyPath: KeyPath<L21, SFSymbol>) -> SFSymbol {
        L21(source: self)[keyPath: keyPath]
    }
}
