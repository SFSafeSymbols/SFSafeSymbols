#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

@available(macOS 11.0, *)
public extension NSImage {

    /// Retrieve a system symbol image of the given type.
    ///
    /// - Parameter systemSymbol: The `SFSymbol` describing this image.
    /// - Parameter accessibilityDescription: The accessibility description for the image.
    @available(macOS 11.0, *)
    convenience init?(systemSymbol: SFSymbol, accessibilityDescription description: String? = nil) {
        self.init(systemSymbolName: systemSymbol.rawValue, accessibilityDescription: description)!
    }
}

#endif
