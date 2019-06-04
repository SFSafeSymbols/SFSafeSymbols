#if os(iOS) || os(tvOS) || os(watchOS)

import UIKit

public extension UIImage {
    /// TODO: Document
    @available(iOS 13.0, *)
    convenience init(systemSymbol: SFSymbol) {
        guard let _ = UIImage(systemName: systemSymbol.rawValue) else {
            fatalError("Unknown system symbol")
        }

        /// TODO: Avoid double init
        self.init(systemName: systemSymbol.rawValue)!
    }

    /// TODO: Document
    @available(iOS 13.0, *)
    convenience init(systemSymbol: SFSymbol, withConfiguration configuration: UIImage.Configuration?) {
        guard let _ = UIImage(systemName: systemSymbol.rawValue, withConfiguration: configuration) else {
            fatalError("Unknown system symbol")
        }

        /// TODO: Avoid double init
        self.init(systemName: systemSymbol.rawValue, withConfiguration: configuration)!
    }

    /// TODO: Document
    @available(iOS 13.0, *)
    convenience init(systemSymbol: SFSymbol, compatibleWith traitCollection: UITraitCollection?) {
        guard let _ = UIImage(systemName: systemSymbol.rawValue, compatibleWith: traitCollection) else {
            fatalError("Unknown system symbol")
        }

        /// TODO: Avoid double init
        self.init(systemName: systemSymbol.rawValue, compatibleWith: traitCollection)!
    }
}

#endif
