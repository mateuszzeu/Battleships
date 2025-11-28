//
//  Ship.swift
//  Battleships
//
//  Created by MAT on 27/11/2025.
//

import Foundation

struct Ship {
    let size: Int
    let position: Position
    let direction: Direction
    var hitPositions: Set<Position>
}
