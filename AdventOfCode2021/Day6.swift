import Foundation

fileprivate extension Array where Element == Int {
    static let newbornCooldown = 8
    static let postbirthCooldown = 6
    
    func iterateLanternfish(iterationCount: Int) -> Int {
        let mapping = reduce(into: Array(repeating: 0, count: Self.newbornCooldown + 1)) { result, health in
            result[health] += 1
        }
        
        return (0..<iterationCount).reduce(mapping) { result, _ in
            Array(result.suffix(from: 1) + result.prefix(1))
                .enumerated()
                .map { $0.element + ($0.offset == Self.postbirthCooldown ? result[0] : 0) }
        }.sum
    }
}

struct Day6: Day {
    static let inputData = "3,4,3,1,2"

    static func execute() {
        let parsedData = inputData.components(separatedBy: .punctuationCharacters).compactMap(Int.init)
        
        // Task 1
        let solution1 = parsedData.iterateLanternfish(iterationCount: 80)
        print(solution1)
        
        // Task 2
        let solution2 = parsedData.iterateLanternfish(iterationCount: 256)
        print(solution2)
    }
}
