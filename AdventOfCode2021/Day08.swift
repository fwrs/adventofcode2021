import Foundation

private struct Line {
    let clues: [String]
    let output: [String]
    
    var total: Set<Set<Character>> { Set((clues + output).map { Set($0) }) }

    func solve1() -> Int {
        output.count { [2, 4, 3, 7].contains($0.count) }
    }
    
    func solve2() -> Int? {
        let eight = Set("abcdefg")
        let sixSegmented = total.filter { $0.count == 6 }
        
        guard let one   = total.first(where: { $0.count == 2 }),
              let four  = total.first(where: { $0.count == 4 }),
              let seven = total.first(where: { $0.count == 3 }),
              let nine  = sixSegmented.first(where: { $0.isSuperset(of: four.union(seven)) }),
              let zero  = sixSegmented.subtracting([nine]).first(where: { $0.isSuperset(of: one) }),
              let six   = sixSegmented.subtracting([nine, zero]).first,
              let a     = seven.subtracting(one).first,
              let c     = eight.subtracting(six).first,
              let d     = eight.subtracting(zero).first,
              let b     = four.subtracting(one + [d]).first,
              let e     = eight.subtracting(nine).first,
              let g     = nine.subtracting(four.union(seven)).first else { return nil }
        
        let two = Set([a, c, d, e, g])
        let three = nine.subtracting([b])
        let five = six.subtracting([e])
        
        let mapping = [zero: 0, one: 1, two: 2, three: 3, four: 4, five: 5, six: 6, seven: 7, eight: 8, nine: 9]
        return output.compactMap { mapping[Set($0)] }.reduce(0) { $0 * 10 + $1 }
    }
}

struct Day8: Day {
    static let inputData = "<#Fill in the input data here.#>"
    
    static func execute() {
        let parsedData = inputData
            .components(separatedBy: .newlines)
            .map { $0.components(separatedBy: " | ").map { $0.components(separatedBy: .whitespaces) } }
            .filter { $0.count == 2 }
            .map { Line(clues: $0[0], output: $0[1]) }
        
        // Task 1
        let solution1 = parsedData.reduce(0) { $0 + $1.solve1() }
        print(solution1)
        
        // Task 2
        let solution2 = parsedData.reduce(0) { $0 + ($1.solve2() ?? 0) }
        print(solution2)
    }
}
