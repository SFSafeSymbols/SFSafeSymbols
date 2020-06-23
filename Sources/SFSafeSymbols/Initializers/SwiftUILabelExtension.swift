#if canImport(SwiftUI)

import SwiftUI

@available(iOS 14.0, OSX 10.16, tvOS 14.0, watchOS 7.0, *)
public extension Label where Title == Text, Icon == Image {
    
    /// Creates a label with a system symbol image and a title generated from a
    /// localized string.
    ///
    /// - Parameter systemSymbol: The `SFSymbol` describing this image.
    init(_ titleKey: LocalizedStringKey, systemSymbol: SFSymbol) {
        self.init(titleKey, systemImage: systemSymbol.rawValue)
    }
    
    /// Creates a label with a system symbol image and a title generated from a
    /// string.
    ///
    /// - Parameter systemSymbol: The `SFSymbol` describing this image.
    init<S>(_ title: S, systemSymbol: SFSymbol) where S : StringProtocol {
        self.init(title, systemImage: systemSymbol.rawValue)
    }
}

#endif
