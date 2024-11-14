//
//  ContentView.swift
//  tictactoe_game
//
//  Created by Gaming Lab on 13/11/24.
//

import SwiftUI

struct ContentView: View {
    // Game state properties
    @State private var board: [[String]] = Array(repeating: Array(repeating: "", count: 3), count: 3)
    @State private var currentPlayer = "X"
    @State private var isGameOver = false
    @State private var gameResult = ""
    
    var body: some View {
        ZStack {
            // Background image from asset
            Image("rm222-mind-20") // Ensure the image name matches your asset
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                Text("Tic Tac Toe")
                    .font(.largeTitle)
                    .padding()
                    .foregroundColor(.white) // Ensure visibility against the background
                
                // Display game board
                VStack(spacing: 5) {
                    ForEach(0..<3) { row in
                        HStack(spacing: 5) {
                            ForEach(0..<3) { col in
                                CellView(symbol: $board[row][col])
                                    .onTapGesture {
                                        handleTap(row: row, col: col)
                                    }
                            }
                        }
                    }
                }
                .padding()
                
                // Display current player
                Text("Current Player: \(currentPlayer)")
                    .font(.title2)
                    .padding()
                    .foregroundColor(.white) // Ensure visibility

                // Play again button
                if isGameOver {
                    Button("Play Again") {
                        resetGame()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .alert(isPresented: $isGameOver) {
                Alert(title: Text("Game Over"), message: Text(gameResult), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    // Handle cell tap
    private func handleTap(row: Int, col: Int) {
        if board[row][col] == "" && !isGameOver {
            board[row][col] = currentPlayer
            if checkWin(for: currentPlayer) {
                gameResult = "\(currentPlayer) Wins!"
                isGameOver = true
            } else if checkDraw() {
                gameResult = "It's a Draw!"
                isGameOver = true
            } else {
                currentPlayer = currentPlayer == "X" ? "O" : "X"
            }
        }
    }
    
    // Check win condition
    private func checkWin(for player: String) -> Bool {
        // Check rows, columns, and diagonals
        for i in 0..<3 {
            if board[i][0] == player && board[i][1] == player && board[i][2] == player {
                return true
            }
            if board[0][i] == player && board[1][i] == player && board[2][i] == player {
                return true
            }
        }
        if board[0][0] == player && board[1][1] == player && board[2][2] == player {
            return true
        }
        if board[0][2] == player && board[1][1] == player && board[2][0] == player {
            return true
        }
        return false
    }
    
    // Check draw condition
    private func checkDraw() -> Bool {
        for row in board {
            for cell in row {
                if cell == "" {
                    return false
                }
            }
        }
        return true
    }
    
    // Reset the game
    private func resetGame() {
        board = Array(repeating: Array(repeating: "", count: 3), count: 3)
        currentPlayer = "X"
        isGameOver = false
        gameResult = ""
    }
}

// Cell view for each grid cell
struct CellView: View {
    @Binding var symbol: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray)
                .frame(width: 100, height: 100)
            Text(symbol)
                .font(.largeTitle)
                .foregroundColor(.white)
        }
        .cornerRadius(10) // Add rounded corners to cells
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
