import Foundation

struct Day1: Day {
    static let inputData = "<#Fill in the input data here.#>"
    
    static func execute() {
        let parsedData = inputData
            .components(separatedBy: .newlines)
            .compactMap(Int.init)
        
        // Task 1
        let solution1 = parsedData
            .reduce((count: 0, last: Int?.none)) { accum, next in
                (accum.count + Int(next > accum.last ?? next), next)
            }
            .count
        print(solution1)
        
        // Task 2
        let solution2 = parsedData
            .indices
            .reduce((count: 0, last: [Int]())) { accum, next in
                let current = Array(parsedData[safe: next + 1..<next + 4] ?? [])
                return (accum.count + Int(current.sum > accum.last.sum), current)
            }
            .count
        print(solution2)
    }
}
