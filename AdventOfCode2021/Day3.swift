import Foundation

fileprivate extension Array where Element == [Int] {
    var rotated: Self {
        first?.indices.map { index in
            self.map { $0[index] }
        } ?? []
    }
}

fileprivate extension Array where Element == Int {
    func compareHighestOccurences(first: Int, second: Int) -> Int {
        filter { $0 == first }.count > filter { $0 == second }.count ? first : second
    }
    
    func compareLowestOccurences(first: Int, second: Int) -> Int {
        filter { $0 == first }.count < filter { $0 == second }.count ? first : second
    }
    
    var binaryToDecimal: Int {
        Int(map { String($0) }.reduce("", +), radix: 2) ?? 0
    }
}

fileprivate struct Submarine {
    var gammaRate = 0
    var epsilonRate = 0
    
    var oxygenGeneratorRating = 0
    var co2ScrubberRating = 0
    
    mutating func calculate1(using diagnosticReport: [[Int]]) {
        gammaRate = diagnosticReport
            .rotated
            .map { $0.compareHighestOccurences(first: 0, second: 1) }
            .binaryToDecimal
        
        epsilonRate = diagnosticReport
            .rotated
            .map { $0.compareLowestOccurences(first: 0, second: 1) }
            .binaryToDecimal
    }
    
    mutating func calculate2(using diagnosticReport: [[Int]]) {
        oxygenGeneratorRating = diagnosticReport
            .rotated
            .enumerated()
            .reduce(diagnosticReport.enumerated().asPairs) { filteredReport, line in
                let mostCommon = line.element
                    .enumerated()
                    .filter { row in filteredReport.contains { $0.offset == row.offset } }
                    .map { $0.element }
                    .compareHighestOccurences(first: 0, second: 1)
                let newFilteredReport = filteredReport.filter { $0.element[line.offset] != mostCommon }
                return newFilteredReport.isEmpty ? filteredReport : newFilteredReport
            }
            .map { $0.element }
            .first?
            .binaryToDecimal ?? 0
        
        co2ScrubberRating = diagnosticReport
            .rotated
            .enumerated()
            .reduce(diagnosticReport.enumerated().asPairs) { filteredReport, line in
                let leastCommon = line.element
                    .enumerated()
                    .filter { row in filteredReport.contains { $0.offset == row.offset } }
                    .map { $0.element }
                    .compareLowestOccurences(first: 1, second: 0)
                let newFilteredReport = filteredReport.filter { $0.element[line.offset] != leastCommon }
                return newFilteredReport.isEmpty ? filteredReport : newFilteredReport
            }
            .map { $0.element }
            .first?
            .binaryToDecimal ?? 0
    }
    
    var powerConsumption: Int {
        gammaRate * epsilonRate
    }
    
    var lifeSupportRating: Int {
        oxygenGeneratorRating * co2ScrubberRating
    }
}

struct Day3: Day {
    static let inputData = "<#Fill in the input data here.#>"
    
    static func execute() {
        let parsedData = inputData
            .components(separatedBy: .newlines)
            .map { $0.map { Int($0.description) ?? 0 } }
        
        var submarine = Submarine()
        
        // Task 1
        submarine.calculate1(using: parsedData)
        let solution1 = submarine.powerConsumption
        print(solution1)
        
        // Task 2
        submarine.calculate2(using: parsedData)
        let solution2 = submarine.lifeSupportRating
        print(solution2)
    }
}
