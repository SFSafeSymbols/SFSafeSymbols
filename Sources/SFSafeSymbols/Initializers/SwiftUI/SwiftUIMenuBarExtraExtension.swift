#if canImport(SwiftUI)

import SwiftUI

@available(macOS 13.0, *)
public extension MenuBarExtra where Label == SwiftUI.Label<Text, Image> {

    /// Creates a menu bar extra with a system symbol image to use as the items
    /// label. The provided title will be used by the accessibility system.
    ///
    /// - Parameter titleKey: The localized string key to use for the accessibility label of the item.
    /// - Parameter systemSymbol: The `SFSymbol` describing this image. No image is shown if nil is passed.
    /// - Parameter content: A `View` to display when the user selects the item.
    init(_ titleKey: LocalizedStringKey, systemSymbol: SFSymbol?, @ViewBuilder content: () -> Content) {
        self.init(titleKey, systemImage: systemSymbol?.rawValue ?? "", content: content)
    }

    /// Creates a menu bar extra with a system symbol image to use as the items
    /// label. The provided title will be used by the accessibility system.
    ///
    /// - Parameter titleKey: The localized string key to use for the accessibility label of the item.
    /// - Parameter systemSymbol: The `SFSymbol` describing this image. No image is shown if nil is passed.
    /// - Parameter isInserted: Whether the item is inserted in the menu bar. The item may or may not be visible, depending on the number of items present.
    /// - Parameter content: A `View` to display when the user selects the item.
    init(_ titleKey: LocalizedStringKey, systemSymbol: SFSymbol?, isInserted: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.init(titleKey, systemImage: systemSymbol?.rawValue ?? "", isInserted: isInserted, content: content)
    }

    /// Creates a menu bar extra with a system symbol image to use as the items
    /// label. The provided title will be used by the accessibility system.
    ///
    /// - Parameter title: The string to use for the accessibility label of the item.
    /// - Parameter systemSymbol: The `SFSymbol` describing this image. No image is shown if nil is passed.
    /// - Parameter content: A `View` to display when the user selects the item.
    @_disfavoredOverload
    init<S>(_ title: S, systemSymbol: SFSymbol?, @ViewBuilder content: () -> Content) where S: StringProtocol {
        self.init(title, systemImage: systemSymbol?.rawValue ?? "", content: content)
    }

    /// Creates a menu bar extra with a system symbol image to use as the items
    /// label. The provided title will be used by the accessibility system.
    ///
    /// - Parameter title: The string to use for the accessibility label of the item.
    /// - Parameter systemSymbol: The `SFSymbol` describing this image. No image is shown if nil is passed.
    /// - Parameter isInserted: Whether the item is inserted in the menu bar. The item may or may not be visible, depending on the number of items present.
    /// - Parameter content: A `View` to display when the user selects the item.
    @_disfavoredOverload
    init<S>(_ title: S, systemSymbol: SFSymbol?, isInserted: Binding<Bool>, @ViewBuilder content: () -> Content) where S: StringProtocol {
        self.init(title, systemImage: systemSymbol?.rawValue ?? "", isInserted: isInserted, content: content)
    }

}

#endif
