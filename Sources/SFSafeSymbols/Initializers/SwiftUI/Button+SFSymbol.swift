#if canImport(SwiftUI)

import SwiftUI
import AppIntents

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public extension Button where Label == SwiftUI.Label<Text, Image>{
    
    /// Creates a button that generates its label from a string and an `SFSymbol`.
    ///
    /// - Parameters
    ///     - title: A string that describes the purpose of the button’s action.
    ///     - systemSymbol: The `SFSymbol` describing this image.
    ///     - action: The action to perform when the user triggers the button.
    @_disfavoredOverload
    nonisolated init(_ title: some StringProtocol, systemSymbol: SFSymbol, action: @escaping @MainActor () -> Void) {
        self.init(title, systemImage: systemSymbol.rawValue, action: action)
    }

    /// Creates a button that generates its label from a localized string key and an `SFSymbol`.
    ///
    /// - Parameters
    ///     - titleKey: The key for the button’s localized title, that describes the purpose of the button’s action.
    ///     - systemSymbol: The `SFSymbol` describing this image.
    ///     - action: The action to perform when the user triggers the button.
    nonisolated init(_ titleKey: LocalizedStringKey, systemSymbol: SFSymbol, action: @escaping @MainActor () -> Void) {
        self.init(titleKey, systemImage: systemSymbol.rawValue, action: action)
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension Button where Label == SwiftUI.Label<Text, Image> {

    /// Creates a button with a specified role that generates its label from a string and an `SFSymbol`.
    ///
    /// - Parameters
    ///     - title: A string that describes the purpose of the button’s action.
    ///     - systemSymbol: The `SFSymbol` describing this image.
    ///     - role: An optional semantic role describing the button. A value of nil means that the button doesn’t have an assigned role.
    ///     - action: The action to perform when the user triggers the button.
    @_disfavoredOverload
    nonisolated init(_ title: some StringProtocol, systemSymbol: SFSymbol, role: ButtonRole?, action: @escaping @MainActor () -> Void) {
        self.init(title, systemImage: systemSymbol.rawValue, role: role, action: action )
    }

    /// Creates a button with a specified role that generates its label from a localized string key and an `SFSymbol`.
    ///
    /// - Parameters
    ///     - titleKey: The key for the button’s localized title, that describes the purpose of the button’s action
    ///     - systemSymbol: The `SFSymbol` describing this image.
    ///     - role: An optional semantic role describing the button. A value of nil means that the button doesn’t have an assigned role.
    ///     - action: The action to perform when the user triggers the button.
    nonisolated init(_ titleKey: LocalizedStringKey, systemSymbol: SFSymbol, role: ButtonRole?, action: @escaping @MainActor () -> Void) {
        self.init(titleKey, systemImage: systemSymbol.rawValue, role: role, action: action )
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public extension SwiftUI.Button where Label == SwiftUI.Label<Text, Image> {

    /// Creates a button with a specified role that performs an AppIntent and generates its label from a localized string key and an `SFSymbol`.
    ///
    /// - Parameters
    ///     - titleKey: The key for the button’s localized title, that describes the purpose of the button’s intent.
    ///     - systemSymbol: The `SFSymbol` describing this image.
    ///     - role: An optional semantic role describing the button. A value of nil means that the button doesn’t have an assigned role.
    ///     - intent: The AppIntent to execute.
    nonisolated init(_ titleKey: LocalizedStringKey, systemSymbol: SFSymbol, role: ButtonRole? = nil, intent: some AppIntent) {
        self.init(titleKey, systemImage: systemSymbol.rawValue, role: role, intent: intent)
    }

    /// Creates a button with a specified role that generates its label from a string and an `SFSymbol`.
    ///
    /// - Parameters
    ///     - title: A string that describes the purpose of the button’s intent.
    ///     - systemSymbol: The `SFSymbol` describing this image.
    ///     - role: An optional semantic role describing the button. A value of nil means that the button doesn’t have an assigned role.
    ///     - intent: The AppIntent to execute.
    @_disfavoredOverload
    nonisolated init(_ title: some StringProtocol, systemSymbol: SFSymbol, role: ButtonRole? = nil, intent: some AppIntent) {
        self.init(title, systemImage: systemSymbol.rawValue, role: role, intent: intent)
    }
}

#endif
