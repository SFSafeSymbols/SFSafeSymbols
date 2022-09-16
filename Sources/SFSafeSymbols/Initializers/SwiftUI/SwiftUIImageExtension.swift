#if canImport(SwiftUI)

import SwiftUI

@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public extension SwiftUI.Image {
    
    /// Creates a system symbol image.
    ///
    /// - Parameter systemSymbol: The `SFSymbol` describing this image.
    init(systemSymbol: SFSymbol) {
        self.init(systemName: systemSymbol.rawValue)
    }

// AppIntents serves as a placeholder SDK to check if the iOS 16.0, macOS 13.0, ... SDKs are available
#if canImport(AppIntents)
    /// Creates a system symbol image with a variable value.
    ///
    /// - Parameter systemSymbol: The `SFSymbol` describing this image.
    /// - Parameter variableValue: An optional value between 0.0 and 1.0 that the rendered image can use to customize its appearance, if specified. If the symbol doesn’t support variable values, this parameter has no effect. Use the SF Symbols app to look up which symbols support variable values.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    init(systemSymbol: SFSymbol, variableValue: Double?) {
        self.init(systemName: systemSymbol.rawValue, variableValue: variableValue)
    }
#endif
}

#endif
