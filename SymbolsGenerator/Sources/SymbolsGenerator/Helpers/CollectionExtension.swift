extension Collection {
    var isNotEmpty: Bool { !isEmpty }
}

extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var result: [T] = []

        for element in self {
            try await result.append(transform(element))
        }

        return result
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
