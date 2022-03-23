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
