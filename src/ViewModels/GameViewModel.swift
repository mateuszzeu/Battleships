//
//  GameViewModel.swift
//  Battleships
//
//  Created by MAT on 27/11/2025.
//

import Foundation

@Observable
@MainActor
final class GameViewModel {
    var gameStatus: String = "Gotowy"
    var logPath: String?
    var isRunning: Bool = false
    var gameResult: GameResult?
    
    func runGame() async {
        guard !isRunning else { return }
        isRunning = true
        gameStatus = "Symulacja w toku..."
        logPath = nil
        gameResult = nil
        
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd-HHmmss"
        let filename = "ships-game-\(df.string(from: Date())).log"
        
        guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            gameStatus = "Błąd: brak dostępu do dokumentów"
            isRunning = false
            return
        }
        
        let fileURL = documents.appendingPathComponent(filename)
        
        do {
            let path = fileURL.path
            let result = try await Task.detached {
                let logger = try GameLogger(filePath: path)
                let engine = GameEngine(logger: logger)
                return engine.runGame(player1: RandomPlayer(), player2: RandomPlayer())
            }.value
            
            logPath = path
            gameResult = result
            
            if let result {
                gameStatus = "Koniec gry - Gracz \(result.winner) wygrywa!"
            } else {
                gameStatus = "Koniec gry"
            }
            
        } catch {
            gameStatus = "Błąd: \(error.localizedDescription)"
        }
        
        isRunning = false
    }
}
