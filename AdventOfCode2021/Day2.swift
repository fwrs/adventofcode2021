import Foundation

fileprivate enum Direction: String {
    case up, down, forward
}

fileprivate struct Movement {
    let direction: Direction
    let scalar: Int
    
    init?(_ string: String) {
        let components = string.components(separatedBy: .whitespaces)
        
        guard components.count == 2,
            let direction = Direction(rawValue: components[0]),
            let scalar = Int(components[1]) else { return nil }
        
        self.direction = direction
        self.scalar = scalar
    }
}

fileprivate struct Submarine {
    var depth: Int
    var horizontalPosition: Int
    var aim: Int
    
    static var zero: Self { Submarine(depth: .zero, horizontalPosition: .zero, aim: .zero) }
    
    mutating func move1(following rule: Movement) {
        switch rule.direction {
        case .up:
            depth -= rule.scalar
        case .down:
            depth += rule.scalar
        case .forward:
            horizontalPosition += rule.scalar
        }
    }
    
    mutating func move2(following rule: Movement) {
        switch rule.direction {
        case .up:
            aim -= rule.scalar
        case .down:
            aim += rule.scalar
        case .forward:
            horizontalPosition += rule.scalar
            depth += rule.scalar * aim
        }
    }
    
    var product: Int { depth * horizontalPosition }
}

struct Day2: Day {
    static let inputData = "<#Fill in the input data here.#>"
    
    static func execute() {
        let parsedData = inputData
            .components(separatedBy: .newlines)
            .compactMap(Movement.init)
        
        // Task 1
        let solution1 = parsedData
            .reduce(into: Submarine.zero) { submarine, rule in
                submarine.move1(following: rule)
            }
            .product
        print(solution1)
        
        // Task 2
        let solution2 = parsedData
            .reduce(into: Submarine.zero) { submarine, rule in
                submarine.move2(following: rule)
            }
            .product
        print(solution2)
    }
}
