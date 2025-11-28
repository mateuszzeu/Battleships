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

    var body: some View {
        VStack(spacing: 20) {
            Text("Battleships AI")
                .font(.largeTitle)
                .bold()

            Text(viewModel.gameStatus)
                .font(.headline)
                .foregroundColor(viewModel.isRunning ? .blue : .primary)

            if let path = viewModel.logPath {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Log saved to:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(path)
                        .font(.caption2)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(6)
                        .textSelection(.enabled)

                    HStack {
                        ShareLink(item: URL(filePath: path)) {
                            Label("Share log", systemImage: "square.and.arrow.up")
                        }
                        Spacer()
                        Button {
                            UIPasteboard.general.string = path
                        } label: {
                            Label("Copy path", systemImage: "doc.on.doc")
                        }
                    }
                    .font(.caption2)
                }
                .padding(.horizontal)
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
                    } else {
                        Text("Run Game")
                            .bold()
                    }
                }
                .frame(minWidth: 120)
                .padding(.vertical, 8)
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isRunning)

            Spacer()
        }
        .padding()
        .onChange(of: viewModel.logPath) { _, newValue in
            if newValue != nil { showFinishedAlert = true }
        }
        .alert("Simulation finished", isPresented: $showFinishedAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            if let p = viewModel.logPath {
                Text("Log saved to:\n\(p)")
            } else {
                Text("No log path available.")
            }
        }
    }
}

#Preview {
    ContentView()
}
