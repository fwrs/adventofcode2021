import Foundation

private extension Array where Element == [Int] {
    static let offsets = [(-1, 0), (1, 0), (0, -1), (0, 1), (-1, -1), (-1, 1), (1, -1), (1, 1)]
    
    var flattenedGridComponents: [(x: Int, y: Int, value: Int)] {
        map { $0.enumerated().asPairs }.enumerated().asPairs.flatMap { r, e in e.map { (r, $0, $1) } }
    }
    
    var flashCount: Int {
        flatMap { $0 }.count { $0 > 9 }
    }
    
    var stepped: Self? {
        var copy = self
        copy.flattenedGridComponents.filter { $0.value > 9 }.forEach { copy[$0.x][$0.y] = 0 }
        copy.flattenedGridComponents.forEach { copy.flash(row: $0.x, col: $0.y) }
        return copy
    }
    
    mutating func flash(row: Int, col: Int) {
        guard self[safe: row]?[safe: col] != nil else { return }
        self[row][col] += 1
        if self[row][col] == 10 { Array.offsets.forEach { flash(row: row + $0, col: col + $1) } }
    }
    
    func countFlashes(upTo maxIteration: Int = 100) -> Int {
        sequence(first: self, next: \.stepped).dropFirst().prefix(maxIteration).map(\.flashCount).sum
    }
    
    func findIterationWhenAllFlash() -> Int? {
        sequence(first: self, next: \.stepped).enumerated().first { $0.element.flatMap { $0 }.allSatisfy { $0 > 9 } }?.offset
    }
}

struct Day11: Day {
    static let inputData = "<#Fill in the input data here.#>"

    static func execute() {
        let parsedData = inputData
            .components(separatedBy: .newlines)
            .map { $0.map(String.init).compactMap(Int.init) }
        
        // Task 1
        let solution1 = parsedData.countFlashes()
        print(solution1)
        
        // Task 2
        let solution2 = parsedData.findIterationWhenAllFlash() ?? 0
        print(solution2)
    }
}
