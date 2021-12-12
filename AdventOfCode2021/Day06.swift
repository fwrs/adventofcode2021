import Foundation

private extension Array where Element == Int {
    static let newbornCooldown = 8
    static let postbirthCooldown = 7
    
    func iterateLanternfish(iterationCount: Int) -> Int {
        let mapping = reduce(into: Array(repeating: 0, count: Self.newbornCooldown + 1)) { result, health in
            result[health] += 1
        }
        
        return sequence(state: mapping) { result -> [Int] in
            result[Self.postbirthCooldown] += result[0]
            result.rotate(toStartAt: 1)
            return result
        }.enumerated().first { $0.offset == iterationCount - 1 }?.element.sum ?? 0
    }
}

struct Day6: Day {
    static let inputData = "<#Fill in the input data here.#>"

    static func execute() {
        let parsedData = inputData
            .components(separatedBy: .punctuationCharacters)
            .compactMap(Int.init)
        
        // Task 1
        let solution1 = parsedData.iterateLanternfish(iterationCount: 80)
        print(solution1)
        
        // Task 2
        let solution2 = parsedData.iterateLanternfish(iterationCount: 256)
        print(solution2)
    }
}
