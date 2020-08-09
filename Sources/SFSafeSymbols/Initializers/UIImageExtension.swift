#if canImport(UIKit)

import UIKit

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension UIImage {

    /// Retrieve a system symbol image of the given type.
    ///
    /// - Parameter systemSymbol: The `SFSymbol` describing this image.
    @available(iOS 13.0, tvOS 13.0, *)
    @available(watchOS, unavailable)
    convenience init(systemSymbol: SFSymbol) {
        self.init(systemName: systemSymbol.rawValue)!
    }

    /// Retrieve a system symbol image of the given type and with the given configuration.
    ///
    /// - Parameter systemSymbol: The `SFSymbol` describing this image.
    /// - Parameter configuration: The `UIImage.Configuration` applied to this system image.
    @available(iOS 13.0, tvOS 13.0, *)
    @available(watchOS, unavailable)
    convenience init(systemSymbol: SFSymbol, withConfiguration configuration: UIImage.Configuration?) {
        self.init(systemName: systemSymbol.rawValue, withConfiguration: configuration)!
    }
}

#endif

enum TestEnum: String {
    @available(iOS 14.0, *)
    case test

    @available(iOS 12.0, *)
    case test2

    var rawValue: String {
        if #available(iOS 14.0, *) {
            switch self {
            case .test:
                return "bla"

            case .test2:
                return "bla2"
            }
        } else {
            switch self {
            case .test2:
                return "test2"

            case .test:
                fatalError()
            }
        }
    }
}
