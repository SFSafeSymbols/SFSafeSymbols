#if canImport(SwiftUI)
import SwiftUI

public extension Image {

    /// Creates a instance of `Image` with a system symbol image of the given type.
    ///
    /// - Parameter systemSymbol: The `SFSymbol` describing this image.
    init(systemSymbol: SFSymbol) {
        self.init(systemName: systemSymbol.rawValue)
    }

}
#endif
