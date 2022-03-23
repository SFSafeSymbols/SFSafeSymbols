
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public class SFSymbol: RawRepresentable, Equatable, Hashable {
    public let rawValue: String

    required public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
extension SFSymbol {
    static let symbolWithAr = Localizable1Symbol<Ar>(rawValue: "symbolWithAr")
    static let symbolWithArAndZh = Localizable2Symbol<Ar, Zh3_0>(rawValue: "symbolWithArAndZh")
}
