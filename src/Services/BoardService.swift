//
//  BoardService.swift
//  Battleships
//
//  Created by MAT on 27/11/2025.
//

import Foundation

struct BoardService {
    static func canPlaceShip(_ ship: Ship, on board: Board) -> Bool {
        let shipPositions = getAllPositions(for: ship)
        guard shipPositions.allSatisfy({ isValidPosition($0) }) else { return false }
        
        for existingShip in board.ships {
            let existingPositions = getAllPositions(for: existingShip)
            if shipPositions.contains(where: { existingPositions.contains($0) }) { return false }
            if areShipsTouching(shipPositions: shipPositions, existingPositions: existingPositions) { return false }
        }
        
        return true
    }

    static func placeShip(_ ship: Ship, on board: inout Board) {
        board.ships.append(ship)
    }

    static func shoot(at position: Position, on board: inout Board) -> ShotResult? {
        guard isValidPosition(position) else { return nil }
        if board.hits.contains(position) || board.misses.contains(position) { return nil }

        for i in 0..<board.ships.count {
            let shipPositions = getAllPositions(for: board.ships[i])
            if shipPositions.contains(position) {
                board.hits.insert(position)
                board.ships[i].hitPositions.insert(position)
                if board.ships[i].hitPositions.count == board.ships[i].size {
                    return .sunk(shipSize: board.ships[i].size)
                }
                return .hit
            }
        }

        board.misses.insert(position)
        return .miss
    }

    static func allShipsSunk(on board: Board) -> Bool {
        board.ships.allSatisfy { $0.hitPositions.count == $0.size }
    }

    static func getAllPositions(for ship: Ship) -> [Position] {
        (0..<ship.size).map { i in
            ship.direction == .horizontal
                ? Position(ship.position.x + i, ship.position.y)
                : Position(ship.position.x, ship.position.y + i)
        }
    }

    private static func isValidPosition(_ position: Position) -> Bool {
        position.x >= 0 && position.x < 10 && position.y >= 0 && position.y < 10
    }

    private static func areShipsTouching(shipPositions: [Position], existingPositions: [Position]) -> Bool {
        shipPositions.contains { shipPos in
            existingPositions.contains { existingPos in
                let dx = abs(shipPos.x - existingPos.x)
                let dy = abs(shipPos.y - existingPos.y)
                return (dx == 1 && dy == 0) || (dx == 0 && dy == 1)
            }
        }
    }
}
