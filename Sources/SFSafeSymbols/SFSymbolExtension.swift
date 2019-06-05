import UIKit

@available(iOS 13.0, *)
public extension SFSymbol {
    /// Retrieves the corresponding UIImage.
    @available(iOS 13.0, *)
    var toImage: UIImage {
        UIImage(systemSymbol: self)
    }

    /// Retrieves the corresponding UIImage with the given configuration.
    ///
    /// - withConfiguration: The UIImage.Configuration applied to this system image.
    @available(iOS 13.0, *)
    func toImage(withConfiguration configuration: UIImage.Configuration?) -> UIImage {
        UIImage(systemSymbol: self, withConfiguration: configuration)
    }

    /// Retrieves the corresponding UIImage with the given traits.
    ///
    /// - compatibleWith: The UITraitCollection applied to this system image.
    @available(iOS 13.0, *)
    func toImage(compatibleWith traitCollection: UITraitCollection?) -> UIImage {
        UIImage(systemSymbol: self, compatibleWith: traitCollection)
    }
}
