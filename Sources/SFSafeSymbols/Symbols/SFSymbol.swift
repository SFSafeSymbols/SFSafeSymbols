@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
open class SFSymbol: RawRepresentable, Equatable, Hashable {
    public let rawValue: String

    public required init(rawValue: String) {
        self.rawValue = rawValue
    }

    public func hash(into hasher: inout Hasher) {
        rawValue.hash(into: &hasher)
    }

    public static func ==(lhs: SFSymbol, rhs: SFSymbol) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}
