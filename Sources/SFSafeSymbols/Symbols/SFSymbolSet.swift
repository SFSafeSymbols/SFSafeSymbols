/// A collection encompassing all SFSymbols and providing access to localizations.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct SFSymbolSet {
    internal var elements: Set<SFSymbol>
}

// MARK: Sequence
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SFSymbolSet: Sequence {
    public typealias Iterator = AnyIterator<SFSymbol>

    public func makeIterator() -> Iterator {
        var iterator = elements.makeIterator()
        return AnyIterator { iterator.next() }
    }
}

// MARK: Collection
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SFSymbolSet: Collection {
    public typealias Index = Set<SFSymbol>.Index

    public var startIndex: Index { elements.startIndex }
    public var endIndex: Index { elements.endIndex }

    public subscript (position: Index) -> Iterator.Element {
        precondition((startIndex ..< endIndex).contains(position), "Out of bounds")
        return elements[position]
    }

    public func index(after index: Index) -> Index {
        return elements.index(after: index)
    }
}
