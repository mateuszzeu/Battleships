//
//  PlayerProtocol.swift
//  Battleships
//
//  Created by MAT on 27/11/2025.
//

protocol PlayerProtocol {
    func placeShip(size: Int, on board: Board) -> Ship
    func makeShot(on enemyBoard: Board) -> Position
}
