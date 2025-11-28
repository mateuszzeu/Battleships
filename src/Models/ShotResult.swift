//
//  ShotResult.swift
//  Battleships
//
//  Created by MAT on 27/11/2025.
//

import Foundation

enum ShotResult: Equatable {
    case miss
    case hit
    case sunk(shipSize: Int)
}
