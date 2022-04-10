extension Collection {
    var isNotEmpty: Bool { !isEmpty }
}

extension Sequence {
    func sorted<T>(on element: (Element) -> T,
                   by areInIncreasingOrder: (T, T) -> Bool) -> [Element] {
        return sorted { areInIncreasingOrder(element($0), element($1)) }
    }
}
