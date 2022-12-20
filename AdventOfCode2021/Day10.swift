import Foundation

private enum ParenthesesValidationError: Error {
    case unnecessaryClose(char: Character), incomplete(stack: [Character])
}

private extension String {
    func validateParentheses(groups: [(open: Character, close: Character)]) -> ParenthesesValidationError? {
        do {
            let result = try reduce([Character]()) { stack, char in
                if groups.map(\.open).contains(char) {
                    return stack + [char]
                } else if let match = groups.first(where: { $0.close == char }), stack.last == match.open {
                    return Array(stack.dropLast())
                } else {
                    throw ParenthesesValidationError.unnecessaryClose(char: char)
                }
            }
            return .incomplete(stack: result)
        } catch {
            return error as? ParenthesesValidationError
        }
    }
}

private extension Array where Element == Character {
    func completeParentheses(groups: [(open: Character, close: Character)]) -> Self {
        reversed().compactMap { char in groups.first { $0.open == char }?.close }
    }
}

private extension Array {
    var middle: Element? {
        self[(count > 1 ? count - 1 : count) / 2]
    }
}

struct Day10: Day {
    static let inputData = "<#Fill in the input data here.#>"

    static func execute() {
        let parsedData = inputData.components(separatedBy: .newlines)
        let groups: [(Character, Character)] = [("(", ")"), ("[", "]"), ("<", ">"), ("{", "}")]
        let mismatchPoints: [Character: Int] = [")": 3, "]": 57, "}": 1197, ">": 25137]
        let completionPoints: [Character: Int] = [")": 1, "]": 2, "}": 3, ">": 4]
        
        // Task 1
        let solution1 = parsedData
            .reduce(0) {
                if case let .unnecessaryClose(char) = $1.validateParentheses(groups: groups) {
                    return $0 + (mismatchPoints[char] ?? 0)
                }
                return $0
            }
        print(solution1)
        
        // Task 2
        let solution2 = parsedData
            .compactMap {
                if case let .incomplete(stack) = $0.validateParentheses(groups: groups) {
                    return stack.completeParentheses(groups: groups).reduce(0) {
                        (5 * $0) + (completionPoints[$1] ?? 0)
                    }
                }
                return nil
            }
            .sorted()
            .middle ?? 0
        print(solution2)
    }
}
