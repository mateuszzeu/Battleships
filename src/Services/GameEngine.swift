//
//  GameEngine.swift
//  Battleships
//
//  Created by MAT on 27/11/2025.
//

import Foundation

struct GameEngine {
    let logger: GameLogger
    
    init(logger: GameLogger) {
        self.logger = logger
    }
    
    func runGame(player1: PlayerProtocol, player2: PlayerProtocol) {
        defer { logger.close() }
        
        var board1 = Board()
        var board2 = Board()
        
        do {
            try placeShips(for: player1, on: &board1, isPlayer1: true)
            try placeShips(for: player2, on: &board2, isPlayer1: false)
        } catch {
            print("Placement error: \(error)")
            return
        }
        
        var shots1 = 0
        var shots2 = 0
        var current = 1
        
        while true {
            if current == 1 {
                let pos = player1.makeShot(on: board2)
                if let result = BoardService.shoot(at: pos, on: &board2) {
                    shots1 += 1
                    logger.logShot(position: pos, result: result)
                    if BoardService.allShipsSunk(on: board2) {
                        logger.logGameOver(result: "win", totalShots: shots1, enemyTotalShots: shots2)
                        logEnemyShips(board2)
                        return
                    }
                    current = 2
                } else {
                    continue
                }
            } else {
                let pos = player2.makeShot(on: board1)
                if let result = BoardService.shoot(at: pos, on: &board1) {
                    shots2 += 1
                    logger.logEnemyShot(position: pos, result: result)
                    if BoardService.allShipsSunk(on: board1) {
                        logger.logGameOver(result: "lose", totalShots: shots1, enemyTotalShots: shots2)
                        logEnemyShips(board2)
                        return
                    }
                    current = 1
                } else {
                    continue
                }
            }
        }
    }
    
    private func placeShips(for player: PlayerProtocol, on board: inout Board, isPlayer1: Bool) throws {
        let config = [(4, 1), (3, 2), (2, 3), (1, 4)]
        
        for (size, count) in config {
            for _ in 0..<count {
                var placed = false
                var attempts = 0
                while !placed && attempts < 1000 {
                    attempts += 1
                    let ship = player.placeShip(size: size, on: board)
                    if BoardService.canPlaceShip(ship, on: board) {
                        BoardService.placeShip(ship, on: &board)
                        if isPlayer1 {
                            logger.logPlaceShip(size: ship.size, position: ship.position, direction: ship.direction)
                        }
                        placed = true
                    }
                }
                if !placed { throw NSError(domain: "PlaceError", code: 1) }
            }
        }
    }
    
    private func logEnemyShips(_ board: Board) {
        for ship in board.ships {
            logger.logEnemyShip(size: ship.size, position: ship.position, direction: ship.direction)
        }
    }
}
