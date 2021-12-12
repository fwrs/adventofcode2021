import Foundation

struct Day7: Day {
    static let inputData = "<#Fill in the input data here.#>"

    static func execute() {
        let parsedData = inputData
            .components(separatedBy: .punctuationCharacters)
            .compactMap(Int.init)
        let max = parsedData.max() ?? 0
        
        // Task 1
        let solution1 = (0..<max)
            .map { position in parsedData.reduce(0) { $0 + abs(position - $1) } }
            .min() ?? 0
        print(solution1)
        
        // Task 2
        let solution2 = (0..<max)
            .map { position in parsedData.reduce(0) {
                let diff = abs(position - $1)
                return $0 + (diff * (diff + 1)) / 2
            } }
            .min() ?? 0
        print(solution2)
    }
}
