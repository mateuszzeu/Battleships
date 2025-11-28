//
//  GameLogger.swift
//  Battleships
//
//  Created by MAT on 27/11/2025.
//

import Foundation

struct GameLogger {
    private let fileHandle: FileHandle
    private let dateFormatter: DateFormatter
    
    init(filePath: String) throws {
        let url = URL(fileURLWithPath: filePath)
        FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)
        self.fileHandle = try FileHandle(forWritingTo: url)
        self.fileHandle.seekToEndOfFile()
        
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss.SSS"
        self.dateFormatter = df
    }
    
    func logPlaceShip(size: Int, position: Position, direction: Direction) {
        log("place-ship: size=\(size) pos=(\(position.x),\(position.y)) dir=\(directionString(direction))")
    }
    
    func logShot(position: Position, result: ShotResult) {
        log("shot: pos=(\(position.x),\(position.y)) result=\(formatShotResult(result))")
    }
    
    func logEnemyShot(position: Position, result: ShotResult) {
        log("enemy-shot: pos=(\(position.x),\(position.y)) result=\(formatShotResult(result))")
    }
    
    func logGameOver(result: String, totalShots: Int, enemyTotalShots: Int) {
        log("game-over: result=\(result) total-shots=\(totalShots) enemy-total-shots=\(enemyTotalShots)")
    }
    
    func logEnemyShip(size: Int, position: Position, direction: Direction) {
        log("enemy-ship: size=\(size) pos=(\(position.x),\(position.y)) dir=\(directionString(direction))")
    }
    
    private func log(_ message: String) {
        let timestamp = dateFormatter.string(from: Date())
        let line = "\(timestamp) \(message)\n"
        if let data = line.data(using: .utf8) {
            fileHandle.write(data)
            fileHandle.synchronizeFile()
        }
    }
    
    private func formatShotResult(_ result: ShotResult) -> String {
        switch result {
        case .miss: return "miss"
        case .hit: return "hit"
        case .sunk(let size): return "sunk ship-size=\(size)"
        }
    }
    
    private func directionString(_ d: Direction) -> String {
        d == .horizontal ? "horizontal" : "vertical"
    }
    
    func close() {
        fileHandle.closeFile()
    }
}
