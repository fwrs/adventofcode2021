import Foundation

private extension String {
    var isBig: Bool { first?.isUppercase == true }
    var isSmall: Bool { first?.isLowercase == true }
    
    static let start = "start"
    static let end = "end"
}

private extension Dictionary where Key == String, Value == [String] {
    func findAllPaths(node: String = .start, visited: [String] = [], allowSmallCavesTwice: Bool = false) -> [[String]] {
        let withNode = visited + [node]
        guard node != .end else { return [withNode] }
        guard let next = self[node] else { return [] }
        
        return next.filter { nextNode in
            nextNode.isBig ||
            !visited.contains(nextNode) ||
            (allowSmallCavesTwice &&
                !(nextNode == .start ||
                  Set(withNode.filter(\.isSmall)).count < withNode.filter(\.isSmall).count &&
                  withNode.contains(nextNode)))
        }.flatMap { findAllPaths(node: $0, visited: withNode, allowSmallCavesTwice: allowSmallCavesTwice) }
    }
}

struct Day12: Day {
    static let inputData = "<#Fill in the input data here.#>"

    static func execute() {
        let parsedData = inputData
            .components(separatedBy: .newlines)
            .map { $0.components(separatedBy: "-") }
            .filter { $0.count == 2 }
            .map { ($0[0], $0[1]) }
        
        let mapping = Dictionary(uniqueKeysWithValues: (parsedData + parsedData.map { ($0.1, $0.0) })
                                    .sorted { $0.0 > $1.0 }
                                    .chunked(on: \.0).map { ($0.0, $0.1.map { $1 }) })
        
        // Task 1
        let solution1 = mapping.findAllPaths()
        print(solution1.count)
        
        // Task 2
        let solution2 = mapping.findAllPaths(allowSmallCavesTwice: true)
        print(solution2.count)
    }
}
