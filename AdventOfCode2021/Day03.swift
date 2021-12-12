import Foundation

private extension Array where Element == [Int] {
    var rotated: Self {
        first?.indices.map { index in
            self.map { $0[index] }
        } ?? []
    }
}

private extension Array where Element == Int {
    var binaryToDecimal: Int {
        Int(map { String($0) }.reduce("", +), radix: 2) ?? 0
    }
    
    func findMoreCommon(_ first: Int, _ second: Int, using comparisonFunction: (Int, Int) -> Bool) -> Int {
        comparisonFunction(count { $0 == first }, count { $0 == second }) ? first : second
    }
}

private struct Submarine {
    static func calculatePowerConsumption(using diagnosticReport: [[Int]]) -> Int {
        let gammaRate = diagnosticReport
            .rotated
            .map { $0.findMoreCommon(0, 1, using: >) }
            .binaryToDecimal
        
        let epsilonRate = diagnosticReport
            .rotated
            .map { $0.findMoreCommon(0, 1, using: <) }
            .binaryToDecimal
        
        return gammaRate * epsilonRate
    }
    
    static func calculateLifeSupportRating(using diagnosticReport: [[Int]]) -> Int {
        let oxygenGeneratorRating = diagnosticReport
            .rotated
            .enumerated()
            .reduce(diagnosticReport.enumerated().asPairs) { filteredReport, line in
                let mostCommon = line.element
                    .enumerated()
                    .filter { row in filteredReport.contains { $0.offset == row.offset } }
                    .map { $0.element }
                    .findMoreCommon(0, 1, using: >)
                let newFilteredReport = filteredReport.filter { $0.element[line.offset] != mostCommon }
                return newFilteredReport.isEmpty ? filteredReport : newFilteredReport
            }
            .map { $0.element }
            .first?
            .binaryToDecimal ?? 0
        
        let co2ScrubberRating = diagnosticReport
            .rotated
            .enumerated()
            .reduce(diagnosticReport.enumerated().asPairs) { filteredReport, line in
                let leastCommon = line.element
                    .enumerated()
                    .filter { row in filteredReport.contains { $0.offset == row.offset } }
                    .map { $0.element }
                    .findMoreCommon(1, 0, using: <)
                let newFilteredReport = filteredReport.filter { $0.element[line.offset] != leastCommon }
                return newFilteredReport.isEmpty ? filteredReport : newFilteredReport
            }
            .map { $0.element }
            .first?
            .binaryToDecimal ?? 0
        
        return oxygenGeneratorRating * co2ScrubberRating
    }
}

struct Day3: Day {
    static let inputData = "<#Fill in the input data here.#>"
    
    static func execute() {
        let parsedData = inputData
            .components(separatedBy: .newlines)
            .map { $0.map(String.init).compactMap(Int.init) }
        
        // Task 1
        let solution1 = Submarine.calculatePowerConsumption(using: parsedData)
        print(solution1)
        
        // Task 2
        let solution2 = Submarine.calculateLifeSupportRating(using: parsedData)
        print(solution2)
    }
}
