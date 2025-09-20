#if canImport(SwiftUI)

import SwiftUI

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public extension Tab where Value: Hashable, Content : View, Label == DefaultTabLabel {
    
    /// Creates a tab that the tab view presents when the tab view's selection
    /// matches the tab's value using a `SFSymbol` with a localized string key label.
    ///
    /// - Parameters:
    ///     - titleKey: The localized string key label for the tab's tab item.
    ///     - systemSymbol: The `SFSymbol` describing this image.
    ///     - value: The `selection` value which selects this tab.
    ///     - content: The view content of the tab.
    nonisolated init(_ titleKey: LocalizedStringKey, systemSymbol: SFSymbol, value: Value, @ViewBuilder content: () -> Content) {
        self.init(titleKey, systemImage: systemSymbol.rawValue, value: value, content: content)
    }


    /// Creates a tab that the tab view presents when the tab view's selection
    /// matches the tab's value using a system image for the tab's tab item image,
    /// with a localized string key label.
    ///
    /// - Parameters:
    ///     - titleResource: The localized string resource label for the tab's
    ///       tab item.
    ///     - systemImage: The system image for the tab's tab item.
    ///     - value: The `selection` value which selects this tab.
    ///     - content: The view content of the tab.
    @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
    nonisolated init(_ titleResource: LocalizedStringResource, systemSymbol: SFSymbol, value: Value, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.init(titleResource, systemImage: systemSymbol.rawValue, value: value,  content: content)
    }
}

#endif
