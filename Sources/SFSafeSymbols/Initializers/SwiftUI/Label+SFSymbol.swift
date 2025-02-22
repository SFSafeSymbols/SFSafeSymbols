#if canImport(SwiftUI)

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public extension Label where Title == Text, Icon == Image {
    
    /// Creates a label with a system symbol image and a title generated from a
    /// localized string.
    ///
    /// - Parameter systemSymbol: The `SFSymbol` describing this image. No image is shown if nil is passed.
    nonisolated init(_ titleKey: LocalizedStringKey, systemSymbol: SFSymbol?) {
        self.init(titleKey, systemImage: systemSymbol?.rawValue ?? "")
    }
    
    /// Creates a label with a system symbol image and a title generated from a
    /// string.
    ///
    /// - Parameter systemSymbol: The `SFSymbol` describing this image. No image is shown if nil is passed.
    @_disfavoredOverload
    nonisolated init(_ title: some StringProtocol, systemSymbol: SFSymbol?) {
        self.init(title, systemImage: systemSymbol?.rawValue ?? "")
    }
}

#endif
