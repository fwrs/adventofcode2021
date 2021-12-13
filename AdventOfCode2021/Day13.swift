import Algorithms
import Foundation

private extension Array where Element == [Bool] {
    var rotated: Self {
        first?.indices.map { index in
            self.map { $0[index] }
        } ?? []
    }
    
    func trim(fold: Fold) -> [[Bool]] {
        fold.direction == .x ? map { [Bool]($0.prefix(fold.extent)) } : Array(prefix(fold.extent))
    }
}

private struct Fold {
    enum Direction: String { case x, y }
    
    let direction: Direction
    let extent: Int
    
    var isX: Bool { direction == .x }
    
    init?(stringValue: String) {
        let components = stringValue.components(separatedBy: "=")
        
        guard components.count == 2,
              let directionString = components[0].last.map(String.init),
              let direction = Direction(rawValue: directionString),
              let extent = Int(components[1]) else { return nil }
        
        self.direction = direction
        self.extent = extent
    }
}

private struct Grid {
    let elements: [[Bool]]
    
    var pretty: String {
        elements.map { $0.map { $0 ? "#" : " " }.reduce("", +) }.joined(separator: "\n")
    }
    
    func apply(fold: Fold) -> Self {
        var newElements = elements.trim(fold: fold)
        
        let prod = fold.direction == .x ?
            product(elements.indices.prefix(fold.extent), elements.indices) :
            product(elements.rotated.indices, elements.rotated.indices.prefix(fold.extent))
        
        for (x, y) in prod {
            let keyPath = fold.direction == .x ?
                \[[Bool]][y][2 * fold.extent - x] :
                \[[Bool]][2 * fold.extent - y][x]
            newElements[y][x] = elements[y][x] || elements[keyPath: keyPath]
        }
        
        return Grid(elements: newElements)
    }
}

struct Day13: Day {
    static let inputData = "<#Fill in the input data here.#>"
    
    static func execute() {
        let points = inputData
            .components(separatedBy: .newlines)
            .prefix { !$0.isEmpty }
            .map { $0.components(separatedBy: .punctuationCharacters).compactMap(Int.init) }
            .filter { $0.count == 2 }
            .map { (x: $0[0], y: $0[1]) }
        
        let folds = inputData
            .components(separatedBy: .newlines)
            .suffix { !$0.isEmpty }
            .compactMap(Fold.init)
        
        let maxX = points.map(\.x).max() ?? 0
        let maxY = points.map(\.y).max() ?? 0
        
        var elements: [[Bool]] = Array(repeating: .init(repeating: false, count: maxX + 1), count: maxY + 2)
        for coordinate in points {
            elements[coordinate.y][coordinate.x] = true
        }
        
        let grid = Grid(elements: elements)
        
        // Task 1
        let solution1 = folds.first.map { grid.apply(fold: $0).elements.flatMap { $0 }.count { $0 } } ?? 0
        print(solution1)
        
        // Task 2
        let solution2 = folds.reduce(grid) { $0.apply(fold: $1) }.pretty
        print(solution2)
    }
}
