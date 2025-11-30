//
//  ContentView.swift
//  Battleships
//
//  Created by MAT on 27/11/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = GameViewModel()
    @State private var showFinishedAlert = false
    
    private let mainBackground = Color(red: 213/255, green: 226/255, blue: 217/255)
    private let textColor = Color(red: 46/255, green: 103/255, blue: 106/255)
    private let emptyColor = Color(red: 200/255, green: 200/255, blue: 200/255)

    var body: some View {
        ZStack {
            mainBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("Battleships")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(textColor)

                    Text(viewModel.gameStatus)
                        .font(.headline)
                        .foregroundColor(textColor)

                    if let result = viewModel.gameResult {
                        Text("Gracz 1")
                            .font(.headline)
                            .foregroundColor(textColor)
                        BoardView(board: result.board1)
                        
                        Text("Gracz 2")
                            .font(.headline)
                            .foregroundColor(textColor)
                        BoardView(board: result.board2)
                        
                        LegendView()
                    }

                    if let path = viewModel.logPath {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ścieżka zapisu log:")
                                .font(.caption)
                                .foregroundColor(textColor)
                                .frame(maxWidth: .infinity, alignment: .center)
                            Text(path)
                                .font(.caption2)
                                .padding(8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(emptyColor)
                                .cornerRadius(6)
                                .foregroundColor(textColor)
                                .textSelection(.enabled)

                            HStack {
                                ShareLink(item: URL(filePath: path)) {
                                    Label("Udostępnij log", systemImage: "square.and.arrow.up")
                                }
                                Spacer()
                                Button {
                                    UIPasteboard.general.string = path
                                } label: {
                                    Label("Kopiuj ścieżkę", systemImage: "doc.on.doc")
                                }
                            }
                            .font(.caption2)
                            .foregroundColor(textColor)
                        }
                    }

                    Button {
                        Task {
                            await viewModel.runGame()
                        }
                    } label: {
                        Group {
                            if viewModel.isRunning {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .tint(.white)
                            } else {
                                Text("Uruchom grę")
                                    .bold()
                            }
                        }
                        .frame(minWidth: 120)
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(textColor)
                    .disabled(viewModel.isRunning)

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
        }
        .onChange(of: viewModel.logPath) { _, newValue in
            if newValue != nil { showFinishedAlert = true }
        }
        .alert("Symulacja zakończona", isPresented: $showFinishedAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            if let p = viewModel.logPath {
                Text("Log zapisany w:\n\(p)")
            } else {
                Text("Brak ścieżki do loga.")
            }
        }
    }
}

#Preview {
    ContentView()
}
