import Foundation

fileprivate struct Line {
    let origin: (x: Int, y: Int)
    let destination: (x: Int, y: Int)
    
    var minX: Int { min(origin.x, destination.x) }
    var minY: Int { min(origin.y, destination.y) }
    var maxX: Int { max(origin.x, destination.x) }
    var maxY: Int { max(origin.y, destination.y) }
    var maxDimension: Int { max(maxX, maxY) }
    
    init?(_ string: String) {
        let components = string
            .components(separatedBy: " -> ")
            .map { $0.components(separatedBy: ",") }
            .flatMap { $0 }
            .compactMap(Int.init)
        
        guard components.count == 4 else { return nil }
        
        origin = (components[0], components[1])
        destination = (components[2], components[3])
    }
    
    func convertToMatrix(size: Int, countDiagonals: Bool = false) -> [[Int]] {
        var matrix = Array.empty(size: size)
        if origin.y == destination.y {
            for i in minX...maxX {
                matrix[origin.y][i] = 1
            }
        } else if origin.x == destination.x {
            for i in minY...maxY {
                matrix[i][origin.x] = 1
            }
        } else if countDiagonals {
            var x = origin.x
            var y = origin.y
            for _ in minX...maxX {
                matrix[y][x] = 1
                x += minX == origin.x ? 1 : -1
                y += minY == origin.y ? 1 : -1
            }
        }
        return matrix
    }
}

extension Array where Element == [Int] {
    static func empty(size: Int) -> Self {
        Array(repeating: .init(repeating: 0, count: size + 1), count: size + 1)
    }
    
    func adding(matrix: [[Int]]) -> [[Int]] {
        zip(self, matrix).map { zip($0, $1).map(+) }
    }
}

struct Day5: Day {
    static let inputData = "<#Fill in the input data here.#>"

    static func execute() {
        let parsedData = inputData
            .components(separatedBy: .newlines)
            .compactMap(Line.init)
        
        let maxDimension = parsedData.map(\.maxDimension).max() ?? 0
        
        // Task 1
        let solution1 = parsedData
            .map { $0.convertToMatrix(size: maxDimension) }
            .reduce(Array.empty(size: maxDimension)) { $0.adding(matrix: $1) }
            .flatMap { $0 }
            .count { $0 > 1 }
        print(solution1)
        
        // Task 2
        let solution2 = parsedData
            .map { $0.convertToMatrix(size: maxDimension, countDiagonals: true) }
            .reduce(Array.empty(size: maxDimension)) { $0.adding(matrix: $1) }
            .flatMap { $0 }
            .count { $0 > 1 }
        print(solution2)
    }
}
