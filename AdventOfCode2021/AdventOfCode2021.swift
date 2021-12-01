extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension Array {
    subscript(safe range: Range<Index>) -> ArraySlice<Element>? {
        if range.endIndex > endIndex {
            if range.startIndex >= endIndex {
                return nil
            }
            return self[range.startIndex..<endIndex]
        }
        if range.startIndex < 0 {
            return nil
        }
        return self[range]
    }
}

extension Array where Element == Int {
    var sum: Int { reduce(0, +) }
}

extension ExpressibleByIntegerLiteral {
    init(_ booleanLiteral: BooleanLiteralType) {
        self = booleanLiteral ? 1 : 0
    }
}

@main class AdventOfCode2021 {
    static func main() {
        Day1.execute()
    }
}

