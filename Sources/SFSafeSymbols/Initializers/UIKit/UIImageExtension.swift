#if canImport(UIKit)

import UIKit

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension UIImage {

    /// Retrieve a system symbol image of the given type.
    ///
    /// - Parameter systemSymbol: The `SFSymbol` describing this image.
    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    convenience init(systemSymbol: SFSymbol) {
        self.init(systemName: systemSymbol.rawValue)!
    }

    /// Retrieve a system symbol image of the given type and with the given configuration.
    ///
    /// - Parameter systemSymbol: The `SFSymbol` describing this image.
    /// - Parameter configuration: The `UIImage.Configuration` applied to this system image.
    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    convenience init(systemSymbol: SFSymbol, withConfiguration configuration: UIImage.Configuration?) {
        self.init(systemName: systemSymbol.rawValue, withConfiguration: configuration)!
    }
}

#endif
