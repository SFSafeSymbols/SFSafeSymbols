extension Collection {
    var isNotEmpty: Bool { !isEmpty }
}

extension Sequence {
    func sorted<T>(on element: (Element) -> T,
                   by areInIncreasingOrder: (T, T) -> Bool) -> [Element] {
        return sorted { areInIncreasingOrder(element($0), element($1)) }
    }
}

infix operator ×
internal func ×<A, B>(lhs: [A], rhs: [B]) -> [(A, B)] {
    var result = [(A, B)]()
    for a in lhs {
        for b in rhs {
            result.append((a, b))
        }
    }
    return result
}
