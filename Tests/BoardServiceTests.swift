//
//  BoardServiceTests.swift
//  Battleships
//
//  Created by MAT on 28/11/2025.
//

import XCTest
@testable import Battleships

final class BoardServiceTests: XCTestCase {
    
    // MARK: - Ship Placement Validation
    
    func test_canPlaceShip_onEmptyBoard_returnsTrue() {
        let board = Board()
        let ship = Ship(size: 3, position: Position(0, 0), direction: .horizontal, hitPositions: [])
        
        XCTAssertTrue(BoardService.canPlaceShip(ship, on: board))
    }
    
    func test_canPlaceShip_outsideBoard_returnsFalse() {
        let board = Board()
        let ship = Ship(size: 4, position: Position(8, 0), direction: .horizontal, hitPositions: [])
        
        XCTAssertFalse(BoardService.canPlaceShip(ship, on: board))
    }
    
    func test_canPlaceShip_overlappingExisting_returnsFalse() {
        var board = Board()
        let existing = Ship(size: 3, position: Position(0, 0), direction: .horizontal, hitPositions: [])
        BoardService.placeShip(existing, on: &board)
        
        let newShip = Ship(size: 2, position: Position(1, 0), direction: .vertical, hitPositions: [])
        
        XCTAssertFalse(BoardService.canPlaceShip(newShip, on: board))
    }
    
    func test_canPlaceShip_touchingSideways_returnsFalse() {
        var board = Board()
        let existing = Ship(size: 2, position: Position(0, 0), direction: .horizontal, hitPositions: [])
        BoardService.placeShip(existing, on: &board)
        
        let adjacent = Ship(size: 2, position: Position(0, 1), direction: .horizontal, hitPositions: [])
        
        XCTAssertFalse(BoardService.canPlaceShip(adjacent, on: board))
    }
    
    func test_canPlaceShip_diagonally_returnsTrue() {
        var board = Board()
        let existing = Ship(size: 2, position: Position(0, 0), direction: .horizontal, hitPositions: [])
        BoardService.placeShip(existing, on: &board)
        
        let diagonal = Ship(size: 2, position: Position(2, 1), direction: .horizontal, hitPositions: [])
        
        XCTAssertTrue(BoardService.canPlaceShip(diagonal, on: board))
    }
    
    // MARK: - Shooting
    
    func test_shoot_atEmptyPosition_returnsMiss() {
        var board = Board()
        let ship = Ship(size: 2, position: Position(5, 5), direction: .horizontal, hitPositions: [])
        BoardService.placeShip(ship, on: &board)
        
        let result = BoardService.shoot(at: Position(0, 0), on: &board)
        
        XCTAssertEqual(result, .miss)
    }
    
    func test_shoot_atShipPosition_returnsHit() {
        var board = Board()
        let ship = Ship(size: 2, position: Position(0, 0), direction: .horizontal, hitPositions: [])
        BoardService.placeShip(ship, on: &board)
        
        let result = BoardService.shoot(at: Position(0, 0), on: &board)
        
        XCTAssertEqual(result, .hit)
    }
    
    func test_shoot_lastShipPosition_returnsSunk() {
        var board = Board()
        let ship = Ship(size: 2, position: Position(0, 0), direction: .horizontal, hitPositions: [])
        BoardService.placeShip(ship, on: &board)
        
        _ = BoardService.shoot(at: Position(0, 0), on: &board)
        let result = BoardService.shoot(at: Position(1, 0), on: &board)
        
        XCTAssertEqual(result, .sunk(shipSize: 2))
    }
    
    func test_shoot_samePositionTwice_returnsNil() {
        var board = Board()
        _ = BoardService.shoot(at: Position(0, 0), on: &board)
        
        let result = BoardService.shoot(at: Position(0, 0), on: &board)
        
        XCTAssertNil(result)
    }
    
    // MARK: - Game State
    
    func test_allShipsSunk_withActiveShips_returnsFalse() {
        var board = Board()
        let ship = Ship(size: 1, position: Position(0, 0), direction: .horizontal, hitPositions: [])
        BoardService.placeShip(ship, on: &board)
        
        XCTAssertFalse(BoardService.allShipsSunk(on: board))
    }
    
    func test_allShipsSunk_allDestroyed_returnsTrue() {
        var board = Board()
        let ship = Ship(size: 1, position: Position(0, 0), direction: .horizontal, hitPositions: [])
        BoardService.placeShip(ship, on: &board)
        _ = BoardService.shoot(at: Position(0, 0), on: &board)
        
        XCTAssertTrue(BoardService.allShipsSunk(on: board))
    }
}
