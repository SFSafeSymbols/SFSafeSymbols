import SwiftUI
import UIKit

@available(iOS 13.0, *)
public extension Image {

    /// Creates a instance of `Image` with a system symbol image of the given type.
    ///
    /// - Parameter systemSymbol: The `SFSymbol` describing this image.
    @available(iOS 13.0, *)
    init(systemSymbol: SFSymbol) {
        self.init(systemName: systemSymbol.rawValue)
    }

    /// Creates a instance of `Image` with a `UIImage` object that has its rendering mode set to `.alwaysTemplate`.
    ///
    /// - Parameter systemSymbol: The `SFSymbol` describing this image.
    /// - Parameter withConfiguration: The `UIImage.Configuration` to use.
    @available(iOS 13.0, *)
    init(systemSymbol: SFSymbol, withConfiguration configuration: UIImage.Configuration) {
        self.init(uiImage: systemSymbol.toImage(withConfiguration: configuration).withRenderingMode(.alwaysTemplate))
    }

    /// Creates a instance of `Image` with a `UIImage` object that has its rendering mode set to `.alwaysTemplate`.
    ///
    /// - Parameter systemSymbol: The `SFSymbol` describing this image.
    /// - Parameter compatibleWith: The `UITraitCollection` applied to this system image.
    @available(iOS 13.0, *)
    init(systemSymbol: SFSymbol, compatibleWith traitCollection: UITraitCollection) {
        self.init(uiImage: systemSymbol.toImage(compatibleWith: traitCollection).withRenderingMode(.alwaysTemplate))
    }

}
