//
//  BoardView.swift
//  Battleships
//
//  Created by MAT on 30/11/2025.
//

import SwiftUI

struct BoardView: View {
    let board: Board
    private let gridSize = 10
    private let cellSize: CGFloat = 28
    
    private let borderColor = Color(red: 46/255, green: 103/255, blue: 106/255)
    private let emptyCell = Color(red: 200/255, green: 200/255, blue: 200/255)
    private let shipColor = Color(red: 54/255, green: 47/255, blue: 22/255)
    private let hitColor = Color(red: 180/255, green: 90/255, blue: 90/255)
    private let missColor = Color(red: 108/255, green: 140/255, blue: 106/255)
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<gridSize, id: \.self) { y in
                HStack(spacing: 0) {
                    ForEach(0..<gridSize, id: \.self) { x in
                        Rectangle()
                            .fill(getCellColor(x: x, y: y))
                            .frame(width: cellSize, height: cellSize)
                            .border(borderColor, width: 0.5)
                    }
                }
            }
        }
        .background(emptyCell)
        .border(borderColor, width: 2)
    }
    
    private func getCellColor(x: Int, y: Int) -> Color {
        let position = Position(x, y)
        
        if board.hits.contains(position) {
            return hitColor
        }

        if board.misses.contains(position) {
            return missColor
        }
        
        for ship in board.ships {
            let positions = BoardService.getAllPositions(for: ship)
            if positions.contains(position) {
                return shipColor
            }
        }
        
        return emptyCell
    }
}

#Preview {
    var board = Board()
    board.ships = [
        Ship(size: 4, position: Position(1, 1), direction: .horizontal, hitPositions: [Position(1, 1), Position(2, 1)]),
        Ship(size: 3, position: Position(5, 3), direction: .vertical, hitPositions: [])
    ]
    board.hits = [Position(1, 1), Position(2, 1)]
    board.misses = [Position(0, 0), Position(7, 7), Position(3, 5)]
    
    return BoardView(board: board)
        .padding()
        .background(Color(red: 213/255, green: 226/255, blue: 217/255))
}
