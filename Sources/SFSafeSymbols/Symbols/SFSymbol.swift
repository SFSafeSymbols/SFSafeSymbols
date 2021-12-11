
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public struct SFSymbol: RawRepresentable, Equatable, Hashable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
