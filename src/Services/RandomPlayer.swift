//
//  RandomPlayer.swift
//  Battleships
//
//  Created by MAT on 27/11/2025.
//

import Foundation

struct RandomPlayer: PlayerProtocol {

    func placeShip(size: Int, on board: Board) -> Ship {
        let dir: Direction = Bool.random() ? .horizontal : .vertical
        let maxX = dir == .horizontal ? 10 - size : 9
        let maxY = dir == .vertical ? 10 - size : 9
        let x = Int.random(in: 0...maxX)
        let y = Int.random(in: 0...maxY)
        return Ship(size: size, position: Position(x, y), direction: dir, hitPositions: [])
    }

    func makeShot(on enemyBoard: Board) -> Position {
        let allPositions = (0..<10).flatMap { x in (0..<10).map { y in Position(x, y) } }
        let available = allPositions.filter { !enemyBoard.hits.contains($0) && !enemyBoard.misses.contains($0) }
        return available.randomElement() ?? Position(0, 0)
    }
}
