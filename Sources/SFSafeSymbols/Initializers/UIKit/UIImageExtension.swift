#if canImport(UIKit)

import UIKit

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension UIImage {

    /// Creates an image object that contains a system symbol image.
    ///
    /// - Parameter systemSymbol: The `SFSymbol` describing this image.
    convenience init(systemSymbol: SFSymbol) {
        self.init(systemName: systemSymbol.rawValue)!
    }

#if !os(watchOS)
    /// Creates an image object that contains a system symbol image appropriate for the specified traits.
    ///
    /// - Parameter systemSymbol: The `SFSymbol` describing this image.
    /// - Parameter traitCollection: The traits associated with the intended environment for the image. Use this parameter to ensure that the correct variant of the image is loaded. If you specify nil, this method uses the traits associated with the main screen.
    convenience init(systemSymbol: SFSymbol, compatibleWith traitCollection: UITraitCollection?) {
        self.init(systemName: systemSymbol.rawValue, compatibleWith: traitCollection)!
    }
#endif

    /// Creates an image object that contains a system symbol image with the specified configuration.
    ///
    /// - Parameter systemSymbol: The `SFSymbol` describing this image.
    /// - Parameter configuration: The image configuration the system applies to the image.
    convenience init(systemSymbol: SFSymbol, withConfiguration configuration: UIImage.Configuration?) {
        self.init(systemName: systemSymbol.rawValue, withConfiguration: configuration)!
    }

// AppIntents serves as a placeholder SDK to check if the iOS 16.0, tvOS 16.0, ... SDKs are available
#if canImport(AppIntents)
    /// Creates an image object that contains a system symbol image with the configuration and variable value you specify.
    ///
    /// - Parameter systemSymbol: The `SFSymbol` describing this image.
    /// - Parameter variableValue: The value the system uses to customize the image content, between 0 and 1.
    /// - Parameter configuration: The image configuration the system applies to the image.
    @available(iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    convenience init(systemSymbol: SFSymbol, variableValue: Double, configuration: UIImage.Configuration?) {
        self.init(systemName: systemSymbol.rawValue, variableValue: variableValue, configuration: configuration)!
    }
#endif
}

#endif
