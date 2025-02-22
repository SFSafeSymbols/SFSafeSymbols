#if canImport(SwiftUI)

import SwiftUI

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *)
public extension ContentUnavailableView where Label == SwiftUI.Label<Text, Image>, Description == Text?, Actions == EmptyView {

    /// Creates an interface, consisting of a title generated from a localized string,
    /// a system symbol image and additional content, that you display when the
    /// content of your app is unavailable to users.
    ///
    /// - Parameter title: A title generated from a localized string.
    /// - Parameter systemSymbol: The `SFSymbol` describing this image. No image is shown if nil is passed.
    /// - Parameter description: The view that describes the interface.
    nonisolated init(_ title: LocalizedStringKey, systemSymbol: SFSymbol?, description: Text? = nil) {
        self.init(title, systemImage: systemSymbol?.rawValue ?? "", description: description)
    }

    /// Creates a label with a system symbol image and a title generated from a
    /// string.
    ///
    /// - Parameter title: A string used as the title.
    /// - Parameter systemSymbol: The `SFSymbol` describing this image. No image is shown if nil is passed.
    /// - Parameter description: The view that describes the interface.
    @_disfavoredOverload
    nonisolated init(_ title: some StringProtocol, systemSymbol: SFSymbol?, description: Text? = nil) {
        self.init(title, systemImage: systemSymbol?.rawValue ?? "", description: description)
    }
}

#endif
