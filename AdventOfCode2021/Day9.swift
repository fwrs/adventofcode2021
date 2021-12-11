import Foundation

fileprivate struct GridItem {
    let number: Int
    var isBorder: Bool { number == 9 }
    var isMarked: Bool = false
    
    init?(stringValue: String) {
        guard let numericValue = Int(stringValue) else { return nil }
        self.number = numericValue
    }
}

fileprivate extension Array where Element == [GridItem] {
    static let offsets = [(0, 0), (-1, 0), (1, 0), (0, -1), (0, 1)]
    
    var flattenedGridComponents: [(x: Int, y: Int, value: GridItem)] {
        map { $0.enumerated().asPairs }.enumerated().asPairs.flatMap { r, e in e.map { (r, $0, $1) } }
    }
    
    mutating func findBasin(row: Int, col: Int) -> Int? {
        guard let item = self[safe: row]?[safe: col], !item.isBorder, !item.isMarked else { return nil }
        self[row][col].isMarked = true
        return Array.offsets.compactMap { findBasin(row: row + $0, col: col + $1) }.sum + 1
    }
}

struct Day9: Day {
    static let inputData = "<#Fill in the input data here.#>"

    static func execute() {
        var parsedData = inputData
            .components(separatedBy: .newlines)
            .map { Array($0).map(String.init).compactMap(GridItem.init) }
        
        // Task 1
        let solution1 = parsedData
            .flattenedGridComponents
            .reduce(0) { accum, item in
                let current = item.value.number
                let isSmallest = Array.offsets.compactMap { parsedData[safe: item.x + $0]?[safe: item.y + $1]?.number }.min() == current
                return accum + (isSmallest ? 1 + current : 0)
            }
        print(solution1)
        
        // Task 2
        let solution2 = parsedData
            .flattenedGridComponents
            .reduce(into: []) { basinSizes, item in
                let current = item.value.number
                let isSmallest = Array.offsets.compactMap { parsedData[safe: item.x + $0]?[safe: item.y + $1]?.number }.min() == current
                if isSmallest, let basinSize = parsedData.findBasin(row: item.x, col: item.y) {
                    basinSizes.append(basinSize)
                }
            }
            .sorted()
            .suffix(3)
            .product
        print(solution2)
    }
}
