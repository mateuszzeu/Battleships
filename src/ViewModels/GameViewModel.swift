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
    var gameStatus: String = "Ready"
    var logPath: String?
    var isRunning: Bool = false

    func runGame() async {
        guard !isRunning else { return }
        isRunning = true
        gameStatus = "Running simulation..."
        logPath = nil

        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd-HHmmss"
        let filename = "ships-game-\(df.string(from: Date())).log"

        guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            gameStatus = "Error: cannot access Documents"
            isRunning = false
            return
        }

        let fileURL = documents.appendingPathComponent(filename)

        do {
            let path = fileURL.path
            try await Task.detached {
                let logger = try GameLogger(filePath: path)
                let engine = GameEngine(logger: logger)
                engine.runGame(player1: RandomPlayer(), player2: RandomPlayer())
            }.value

            logPath = path
            gameStatus = "Game Over"
        } catch {
            gameStatus = "Error: \(error.localizedDescription)"
        }

        isRunning = false
    }
}
