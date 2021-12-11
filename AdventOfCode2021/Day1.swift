import Foundation

struct Day1: Day {
    static let inputData = "<#Fill in the input data here.#>"
    
    static func execute() {
        let parsedData = inputData
            .components(separatedBy: .newlines)
            .compactMap(Int.init)
        
        // Task 1
        let solution1 = parsedData.adjacentPairs().count { $0.0 < $0.1 }
        print(solution1)
        
        // Task 2
        let solution2 = parsedData
            .windows(ofCount: 4)
            .map(Array.init)
            .filter { $0.count == 4 }
            .count { $0[0] < $0[3] }
        print(solution2)
    }
}
