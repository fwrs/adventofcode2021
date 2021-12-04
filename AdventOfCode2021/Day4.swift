import Foundation

fileprivate struct MarkableBingoItem {
    let item: Int
    var isMarked: Bool = false
    var marked: Self { MarkableBingoItem(item: item, isMarked: true) }
}

fileprivate extension Array where Element == [MarkableBingoItem] {
    var rotated: Self {
        first?.indices.map { index in
            self.map { $0[index] }
        } ?? []
    }
    
    var containsMarkedRow: Bool {
        contains { $0.allSatisfy(\.isMarked) } || rotated.contains { $0.allSatisfy(\.isMarked) }
    }
}

fileprivate struct WinnableBingoBoard {
    var board: [[MarkableBingoItem]]
    var hasWon: Bool = false
    var isYetToWin: Bool { !hasWon }
    var lastMarkedItem: Int?
    
    var containsMarkedRow: Bool {
        board.contains { $0.allSatisfy(\.isMarked) } || board.rotated.contains { $0.allSatisfy(\.isMarked) }
    }
    
    func marked(item: Int) -> Self {
        let newBoard = board.map { $0.map { $0.item == item ? $0.marked : $0 } }
        return WinnableBingoBoard(board: newBoard, hasWon: newBoard.containsMarkedRow, lastMarkedItem: item)
    }
    
    var score: Int {
        board.flatMap { $0 }.filter { !$0.isMarked }.map(\.item).reduce(0, +) * (lastMarkedItem ?? 0)
    }
}

fileprivate extension ArraySlice where Element == String {
    var asMatrix: [[MarkableBingoItem]] {
        map { $0.components(separatedBy: .whitespaces).compactMap(Int.init).map { MarkableBingoItem(item: $0) } }
    }
}

struct Day4: Day {
    static let inputData = "<#Fill in the input data here.#>"

    static func execute() {
        var parsedData = inputData.components(separatedBy: .newlines)
        let itemOrder = parsedData.removeFirst().split(separator: ",").compactMap { Int($0) }
        let boards = parsedData.split(separator: "").map(\.asMatrix).map { WinnableBingoBoard(board: $0) }
        
        // Task 1
        let solution1 = itemOrder
            .reduce(boards) { currentBoards, itemToPlay in
                currentBoards.map { $0.hasWon ? $0 : $0.marked(item: itemToPlay) }
            }
            .first(where: \.hasWon)?
            .score ?? 0
        print(solution1)
        
        // Task 2
        let solution2 = itemOrder
            .reduce(boards) { currentBoards, itemToPlay in
                currentBoards.count(where: \.isYetToWin) > 1 ?
                    currentBoards.map { $0.marked(item: itemToPlay) }.filter(\.isYetToWin) :
                    currentBoards.map { $0.hasWon ? $0 : $0.marked(item: itemToPlay) }
            }
            .first(where: \.hasWon)?
            .score ?? 0
        print(solution2)
    }
}
