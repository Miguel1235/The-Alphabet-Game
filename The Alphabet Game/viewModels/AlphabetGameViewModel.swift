//
//  AlphabetGameViewModel.swift
//  The Alphabet Game
//
//  Created by Miguel Del Corso on 12/04/2025.
//

import Foundation
import Observation

@Observable
final class AlphabetGameViewModel {
    var game = ModelData().game
    var timeRemaining = 180
    var currentWordIndex = 0
    var isGameOver = false
    var showGameOverModal = false
    var currentAnswer = ""
    var score = 0
    var noMoreSkips = false
    
    var sanitizedWord: String {
        currentAnswer
            .lowercased()
            .folding(options: .diacriticInsensitive, locale: .current)
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "")
            .components(separatedBy: .punctuationCharacters).joined()
    }
    
    func restartGame() {
        isGameOver = false
        currentAnswer = ""
        score = 0
        noMoreSkips = false
        for i in game.indices {
            game[i].status = .NOT_STARTED
        }
        game[0].status = .CURRENT
        timeRemaining = 180
    }
    
    
    func isTheAnswerCorrect() -> Bool {
        return game[currentWordIndex].answer == sanitizedWord
    }
    
    func moveToNextWord() {
        game[currentWordIndex].status = isTheAnswerCorrect() ? .CORRECT : .FAILED
        score += isTheAnswerCorrect() ? 1 : 0
        
        let possibleMoves = game.indices.filter { game[$0].status == .NOT_STARTED }
        if(possibleMoves.isEmpty) {
            // there are no more moves, finish the game
            isGameOver = true
            showGameOverModal = true
            return
        }
        currentWordIndex = currentWordIndex >= possibleMoves.last! ? possibleMoves.first! : possibleMoves.filter({ $0 > currentWordIndex }).first!
        currentAnswer = ""
    }
    
}
