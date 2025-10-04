#if canImport(SwiftUI)

import SwiftUI

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public extension Tab where Value: Hashable, Content: View, Label : View {
    
    /// Creates a tab that the tab view presents when the tab view's selection
    /// matches the tab's value using a `SFSymbol` with a string label.
    ///
    /// - Parameters:
    ///     - title: The label for the tab's tab item.
    ///     - systemSymbol: The `SFSymbol` describing this image.
    ///     - value: The `selection` value which selects this tab.
    ///     - content: The view content of the tab.
    @_disfavoredOverload
    nonisolated init<S>(_ title: S, systemSymbol: SFSymbol, value: Value, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel, S : StringProtocol {
        self.init(title, systemImage: systemSymbol.rawValue, value: value, content: content)
    }

    /// Creates a tab that the tab view presents when the tab view's selection
    /// matches the tab's value using a `SFSymbol` with a string label.
    ///
    /// - Parameters:
    ///     - title: The label for the tab's tab item.
    ///     - systemSymbol: The `SFSymbol` describing this image.
    ///     - value: The `selection` value which selects this tab.
    ///     - role: The role defining the semantic purpose of the tab.
    ///     - content: The view content of the tab.
    @_disfavoredOverload
    nonisolated init<S>(_ title: S, systemSymbol: SFSymbol, value: Value, role: TabRole?, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel, S : StringProtocol{
        self.init(title, systemImage: systemSymbol.rawValue, value: value, role: role, content: content)
    }
    
    /// Creates a tab that the tab view presents when the tab view's selection
    /// matches the tab's value using a `SFSymbol` with a string label.
    ///
    /// - Parameters:
    ///     - title: The label for the tab's tab item.
    ///     - systemSymbol: The `SFSymbol` describing this image.
    ///     - value: The `selection` value which selects this tab.
    ///     - content: The view content of the tab.
    @_disfavoredOverload
    nonisolated init<S, T>(_ title: S, systemSymbol: SFSymbol, value: T, @ViewBuilder content: () -> Content) where Value == T?, Label == DefaultTabLabel, S : StringProtocol, T : Hashable {
        self.init(title, systemImage: systemSymbol.rawValue, value: value, content: content)
    }

    /// Creates a tab that the tab view presents when the tab view's selection
    /// matches the tab's value using a `SFSymbol` with a string label.
    ///
    /// - Parameters:
    ///     - title: The label for the tab's tab item.
    ///     - systemSymbol: The `SFSymbol` describing this image.
    ///     - value: The `selection` value which selects this tab.
    ///     - role: The role defining the semantic purpose of the tab.
    ///     - content: The view content of the tab.
    @_disfavoredOverload
    nonisolated init<S, T>(_ title: S, systemSymbol: SFSymbol, value: T, role: TabRole?, @ViewBuilder content: () -> Content) where Value == T?, Label == DefaultTabLabel, S : StringProtocol, T : Hashable {
        self.init(title, systemImage: systemSymbol.rawValue, value: value, role: role, content: content)
    }
    
    /// Creates a tab that the tab view presents when the tab view's selection
    /// matches the tab's value using a `SFSymbol` with a localized string key label.
    ///
    /// - Parameters:
    ///     - titleKey: The localized string key label for the tab's tab item.
    ///     - systemSymbol: The `SFSymbol` describing this image.
    ///     - value: The `selection` value which selects this tab.
    ///     - content: The view content of the tab.
    nonisolated init(_ titleKey: LocalizedStringKey, systemSymbol: SFSymbol, value: Value, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.init(titleKey, systemImage: systemSymbol.rawValue, value: value, content: content)
    }

    /// Creates a tab that the tab view presents when the tab view's selection
    /// matches the tab's value using a `SFSymbol` for the tab's tab item image,
    /// with a localized string resource.
    ///
    /// - Parameters:
    ///     - titleResource: The localized string resource label for the tab's
    ///       tab item.
    ///     - systemSymbol: The `SFSymbol` describing this image.
    ///     - value: The `selection` value which selects this tab.
    ///     - content: The view content of the tab.
    @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
    @_disfavoredOverload
    nonisolated init(_ titleResource: LocalizedStringResource, systemSymbol: SFSymbol, value: Value, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.init(titleResource, systemImage: systemSymbol.rawValue, value: value,  content: content)
    }
    
    /// Creates a tab that the tab view presents when the tab view's selection
    /// matches the tab's value using a `SFSymbol` with a localized string key label.
    ///
    /// - Parameters:
    ///     - titleKey: The localized string key label for the tab's tab item.
    ///     - systemSymbol: The `SFSymbol` describing this image.
    ///     - value: The `selection` value which selects this tab.
    ///     - role: The role defining the semantic purpose of the tab.
    ///     - content: The view content of the tab.
    nonisolated init(_ titleKey: LocalizedStringKey, systemSymbol: SFSymbol, value: Value, role: TabRole?, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.init(titleKey, systemImage: systemSymbol.rawValue, value: value, role: role, content: content)
    }

    /// Creates a tab that the tab view presents when the tab view's selection
    /// matches the tab's value using a system image for the tab's tab item image,
    /// with a localized string resource.
    ///
    /// - Parameters:
    ///     - titleResource: The localized string resource label for the tab's
    ///       tab item.
    ///     - systemSymbol: The `SFSymbol` describing this image.
    ///     - value: The `selection` value which selects this tab.
    ///     - role: The role defining the semantic purpose of the tab.
    ///     - content: The view content of the tab.
    @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
    @_disfavoredOverload
    nonisolated init(_ titleResource: LocalizedStringResource, systemSymbol: SFSymbol, value: Value, role: TabRole?, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.init(titleResource, systemImage: systemSymbol.rawValue, value: value, role: role, content: content)
    }
    
    /// Creates a tab that the tab view presents when the tab view's selection
    /// matches the tab's value using a `SFSymbol` with a localized string key label.
    ///
    /// - Parameters:
    ///     - titleKey: The localized string key label for the tab's tab item.
    ///     - systemSymbol: The `SFSymbol` describing this image.
    ///     - value: The `selection` value which selects this tab.
    ///     - content: The view content of the tab.
    nonisolated init<T>(_ titleKey: LocalizedStringKey, systemSymbol: SFSymbol, value: T, @ViewBuilder content: () -> Content) where Value == T?, Label == DefaultTabLabel, T : Hashable {
        self.init(titleKey, systemImage: systemSymbol.rawValue, value: value, content: content)
    }
    
    /// Creates a tab that the tab view presents when the tab view's selection
    /// matches the tab's value using a system image for the tab's tab item image,
    /// with a localized string resource.
    ///
    /// - Parameters:
    ///     - titleResource: The localized string resource label for the tab's
    ///       tab item.
    ///     - systemSymbol: The `SFSymbol` describing this image.
    ///     - value: The `selection` value which selects this tab.
    ///     - content: The view content of the tab.
    @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
    @_disfavoredOverload
    nonisolated init<T>(_ titleResource: LocalizedStringResource, systemSymbol: SFSymbol, value: T, @ViewBuilder content: () -> Content) where Value == T?, Label == DefaultTabLabel, T : Hashable {
        self.init(titleResource, systemImage: systemSymbol.rawValue, value: value, content: content)
    }
        
    /// Creates a tab that the tab view presents when the tab view's selection
    /// matches the tab's value using a `SFSymbol` with a localized string key label.
    ///
    /// - Parameters:
    ///     - titleKey: The localized string key label for the tab's tab item.
    ///     - systemSymbol: The `SFSymbol` describing this image.
    ///     - value: The `selection` value which selects this tab.
    ///     - role: The role defining the semantic purpose of the tab.
    ///     - content: The view content of the tab.
    nonisolated init<T>(_ titleKey: LocalizedStringKey, systemSymbol: SFSymbol, value: T, role: TabRole?, @ViewBuilder content: () -> Content) where Value == T?, Label == DefaultTabLabel, T : Hashable {
        self.init(titleKey, systemImage: systemSymbol.rawValue, value: value, role: role, content: content)
    }
    
    /// Creates a tab that the tab view presents when the tab view's selection
    /// matches the tab's value using a `SFSymbol`  for the tab's tab item image,
    /// with a localized string resource.
    ///
    /// - Parameters:
    ///     - titleResource: The localized string resource label for the tab's
    ///       tab item.
    ///     - systemSymbol: The `SFSymbol` describing this image.
    ///     - value: The `selection` value which selects this tab.
    ///     - role: The role defining the semantic purpose of the tab.
    ///     - content: The view content of the tab.
    @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
    @_disfavoredOverload
    nonisolated init<T>(_ titleResource: LocalizedStringResource, systemSymbol: SFSymbol, value: T, role: TabRole?, @ViewBuilder content: () -> Content) where Value == T?, Label == DefaultTabLabel, T : Hashable {
        self.init(titleResource, systemImage: systemSymbol.rawValue, value: value, role: role, content: content)
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public extension Tab where Value == Never, Content: View, Label: View {
    
    /// Creates a tab with a `SFSymbol` and a string label.
    ///
    /// - Parameters:
    ///     - title: The label for the tab's tab item.
    ///     - systemSymbol: The `SFSymbol` describing this image.
    ///     - content: The view content of the tab.
    @_disfavoredOverload
    nonisolated init<S>(_ title: S, systemSymbol: SFSymbol, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel, S : StringProtocol {
        self.init(title, systemImage: systemSymbol.rawValue, content: content)
    }

    /// Creates a tab with a `SFSymbol` and a string label.
    ///
    /// - Parameters:
    ///     - title: The string label for the tab's tab item.
    ///     - systemSymbol: The `SFSymbol` describing this image.
    ///     - role: The role defining the semantic purpose of the tab.
    ///     - content: The view content of the tab.
    @_disfavoredOverload
    nonisolated init<S>(_ title: S, systemSymbol: SFSymbol, role: TabRole?, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel, S : StringProtocol{
        self.init(title, systemImage: systemSymbol.rawValue, role: role, content: content)
    }

    /// Creates a tab with a `SFSymbol` and a localized string key label.
    ///
    /// - Parameters:
    ///     - titleKey: The localized string key label for the tab's tab item.
    ///     - systemSymbol: The `SFSymbol` describing this image.
    ///     - content: The view content of the tab.
    nonisolated init(_ titleKey: LocalizedStringKey, systemSymbol: SFSymbol, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.init(titleKey, systemImage: systemSymbol.rawValue, content: content)
    }

    /// Creates a tab with a `SFSymbol` and a localized string key label.
    ///
    /// - Parameters:
    ///     - titleKey: The localized string key label for the tab's tab item.
    ///     - systemSymbol: The `SFSymbol` describing this image.
    ///     - role: The role defining the semantic purpose of the tab.
    ///     - content: The view content of the tab.
    nonisolated init(_ titleKey: LocalizedStringKey, systemSymbol: SFSymbol, role: TabRole?, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.init(titleKey, systemImage: systemSymbol.rawValue, role: role, content: content)
    }

    /// Creates a tab with a `SFSymbol` and a localized string resource label.
    ///
    /// - Parameters:
    ///     - titleResource: The localized string resource label for the tab's
    ///       tab item.
    ///     - systemSymbol: The `SFSymbol` describing this image.
    ///     - content: The view content of the tab.
    @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
    @_disfavoredOverload
    nonisolated init(_ titleResource: LocalizedStringResource, systemSymbol: SFSymbol, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.init(titleResource, systemImage: systemSymbol.rawValue, content: content)
    }

    /// Creates a tab with a `SFSymbol` and a localized string resource label.
    ///
    /// - Parameters:
    ///     - titleResource: The localized string resource label for the tab's
    ///       tab item.
    ///     - systemSymbol: The `SFSymbol` describing this image.
    ///     - role: The role defining the semantic purpose of the tab.
    ///     - content: The view content of the tab.
    @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
    @_disfavoredOverload
    nonisolated init(_ titleResource: LocalizedStringResource, systemSymbol: SFSymbol, role: TabRole?, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel {
        self.init(titleResource, systemImage: systemSymbol.rawValue, role: role, content: content)
    }
}

#endif
