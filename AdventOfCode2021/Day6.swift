import Foundation

fileprivate extension Array where Element == Int {
    static let newbornHealth = 8
    static let postbirthHealth = 6
    
    func iterateLanternfish(iterationCount: Int) -> Int {
        var mapping = Array(repeating: 0, count: Self.newbornHealth + 1)
        
        for health in self {
            mapping[health] += 1
        }
        
        for _ in 0..<iterationCount {
            mapping.append(mapping.removeFirst())
            mapping[Self.postbirthHealth] += mapping[Self.newbornHealth]
        }
        
        return mapping.sum
    }
}

struct Day6: Day {
    static let inputData = "<#Fill in the input data here.#>"

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
