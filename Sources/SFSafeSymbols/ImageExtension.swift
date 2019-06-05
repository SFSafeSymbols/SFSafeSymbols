import SwiftUI

@available(iOS 13.0, *)
public extension Image {

    /// Creates a instance of `Image` with a `UIImage` object that has its rendering mode set to `.alwaysTemplate`.
    ///
    /// - systemSymbol: The `SFSymbol` describing this image.
    @available(iOS 13.0, *)
    init(systemSymbol: SFSymbol) {
        self.init(uiImage: systemSymbol.toImage.withRenderingMode(.alwaysTemplate))
    }

}
