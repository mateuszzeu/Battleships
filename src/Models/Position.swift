//
//  Position.swift
//  Battleships
//
//  Created by MAT on 27/11/2025.
//

struct Position: Equatable, Hashable {
    let x: Int
    let y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}
