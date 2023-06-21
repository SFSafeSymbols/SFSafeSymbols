#if canImport(SwiftUI)

import SwiftUI

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public extension ContentUnavailableView where Actions == EmptyView, Description == Text?, Label == SwiftUI.Label<Text, Image> {

    /// Creates an interface, consisting of a title generated from a localized string,
    /// a system symbol image and additional content, that you display when the
    /// content of your app is unavailable to users.
    ///
    /// - Parameter titleKey: A title generated from a localized string.
    /// - Parameter systemSymbol: The `SFSymbol` describing this image. No image is shown if nil is passed.
    /// - Parameter description: The view that describes the interface.
    init(_ titleKey: LocalizedStringKey, systemSymbol: SFSymbol?, description: Text?) {
        self.init(titleKey, systemImage: systemSymbol?.rawValue ?? "", description: description)
    }

    /// Creates a label with a system symbol image and a title generated from a
    /// string.
    ///
    /// - Parameter title: A string used as the title.
    /// - Parameter systemSymbol: The `SFSymbol` describing this image. No image is shown if nil is passed.
    /// - Parameter description: The view that describes the interface.
    @_disfavoredOverload
    init<S>(_ title: S, systemSymbol: SFSymbol?, description: Text?) where S: StringProtocol {
        self.init(title, systemImage: systemSymbol?.rawValue ?? "", description: description)
    }
}

#endif
