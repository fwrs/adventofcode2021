import Foundation

private enum Direction: String {
    case up, down, forward
}

private struct Movement {
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

private struct Submarine {
    let depth: Int
    let progress: Int
    let aim: Int
    
    var product: Int { depth * progress }
    
    internal init(depth: Int = 0, progress: Int = 0, aim: Int = 0) {
        self.depth = depth
        self.progress = progress
        self.aim = aim
    }
    
    func move1(following rule: Movement) -> Self {
        switch rule.direction {
        case .up:
            return .init(depth: depth - rule.scalar, progress: progress)
        case .down:
            return .init(depth: depth + rule.scalar, progress: progress)
        case .forward:
            return .init(depth: depth, progress: progress + rule.scalar)
        }
    }
    
    func move2(following rule: Movement) -> Self {
        switch rule.direction {
        case .up:
            return .init(depth: depth, progress: progress, aim: aim - rule.scalar)
        case .down:
            return .init(depth: depth, progress: progress, aim: aim + rule.scalar)
        case .forward:
            return .init(depth: depth + rule.scalar * aim, progress: progress + rule.scalar, aim: aim)
        }
    }
}

struct Day2: Day {
    static let inputData = "<#Fill in the input data here.#>"
    
    static func execute() {
        let parsedData = inputData
            .components(separatedBy: .newlines)
            .compactMap(Movement.init)
        
        // Task 1
        let solution1 = parsedData
            .reduce(Submarine()) { $0.move1(following: $1) }
            .product
        print(solution1)
        
        // Task 2
        let solution2 = parsedData
            .reduce(Submarine()) { $0.move2(following: $1) }
            .product
        print(solution2)
    }
}
