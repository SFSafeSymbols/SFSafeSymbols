#if canImport(UIKit) && (os(iOS) || targetEnvironment(macCatalyst))

import UIKit

@available(iOS 13.0, *)
public extension UIApplicationShortcutIcon {

    /// Creates a Home screen quick action icon using a system symbol image.
    ///
    /// - Parameter systemSymbol: The `SFSymbol` describing this image.
    convenience init(systemSymbol: SFSymbol) {
        self.init(systemImageName: systemSymbol.rawValue)
    }
}

#endif
