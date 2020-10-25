#if canImport(SwiftUI)

import SwiftUI

@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public extension SwiftUI.Image {
    
    /// Creates a instance of `Image` with a system symbol image of the given type.
    ///
    /// - Parameter systemSymbol: The `SFSymbol` describing this image.
    init(systemSymbol: SFSymbol) {
        self.init(systemName: systemSymbol.rawValue)
    }
}

#endif
