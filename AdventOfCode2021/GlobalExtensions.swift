import Foundation

// Safe indexing
extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// Safe subranging
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

// Sum shorthand
extension Array where Element == Int {
    var sum: Int { reduce(0, +) }
}

// Convert Bool to Int easily
extension ExpressibleByIntegerLiteral {
    init(_ booleanLiteral: BooleanLiteralType) {
        self = booleanLiteral ? 1 : 0
    }
}

// Enumerated sequence annoyances
extension EnumeratedSequence {
    var asPairs: [Element] { map { ($0, $1) } }
}

// Count without filter
extension Collection {
    func count(where test: (Element) throws -> Bool) rethrows -> Int {
        try self.filter(test).count
    }
}
