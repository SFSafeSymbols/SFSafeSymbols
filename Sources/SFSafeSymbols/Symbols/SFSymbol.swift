// Sendable is unchecked, but it's easy to assume it's safe:
// - Classes cannot be overriden outside of SFSafeSymbols, since they are public, not open
// - The only stored property is rawValue, and is immutable (let)
// See https://developer.apple.com/documentation/swift/sendable#Sendable-Classes

@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
public class SFSymbol: RawRepresentable, Equatable, Hashable, @unchecked Sendable {
    public let rawValue: String

    required public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
extension SFSymbol {
    @usableFromInline
    internal convenience init(_ rawValue: String) {
        self.init(rawValue: rawValue)
    }
}

// MARK: Dynamic Localization

@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
public extension SFSymbol {

    /// Determine whether `self` can be localized to `localization` on the current platform.
    ///
    /// - Important: Calling this method links the full symbol catalog (about 1 MB) into your module.
    @_alwaysEmitIntoClient
    func has(localization: Localization) -> Bool {
        Self.allLocalizations[self]?.contains(localization) ?? false
    }

    /// If `self` is localizable to `localization`, localize it, otherwise return `nil`.
    ///
    /// - Important: Calling this method links the full symbol catalog (about 1 MB) into your module.
    @_alwaysEmitIntoClient
    func localized(to localization: Localization) -> SFSymbol? {
        if has(localization: localization) {
            return SFSymbol("\(rawValue).\(localization.rawValue)")
        } else {
            return nil
        }
    }
}
