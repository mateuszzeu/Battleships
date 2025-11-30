//
//  Board.swift
//  Battleships
//
//  Created by MAT on 27/11/2025.
//

struct Board {
    var ships: [Ship]
    var hits: Set<Position>
    var misses: Set<Position>
    
    init() {
        self.ships = []
        self.hits = []
        self.misses = []
    }
}
