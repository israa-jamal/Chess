//
//  AI.swift
//  Chess
//
//  Created by Esraa Gamal on 22/03/2021.
//

import Foundation

class AI {
        
    static let shared = AI()
    let infinite = 10000000
    
    
    func alphaBeta(chessBoard: Board, depth: Int, alpha: Int, beta: Int, isMaximizing: Bool) -> Int{
        
        //Root
        if depth == 0 {
            return Heuristic.shared.evaluate(board: chessBoard)
        }
        
        if isMaximizing {
            var bestScore = -infinite
            for move in chessBoard.getPossibleMoves(color: .white) {
                let copy = Board.clone(chessBoard: chessBoard)
                copy.performMove(move)
                let a = max(alpha, bestScore)
                bestScore = max(bestScore, alphaBeta(chessBoard: copy, depth: depth-1, alpha: a, beta: beta, isMaximizing: false))
                if beta <= a {
                    break
                }
            }
            return bestScore
        } else {
            var bestScore = infinite
            for move in chessBoard.getPossibleMoves(color: .black) {
                let copy = Board.clone(chessBoard: chessBoard)
                copy.performMove(move)
                let b = min(beta, bestScore)
                bestScore = min(bestScore, alphaBeta(chessBoard: copy, depth: depth-1 , alpha: alpha, beta: b, isMaximizing: true))
                if b <= alpha {
                    break
                }
            }
            return bestScore
        }
    }
    
    func getAiMove(chessBoard: Board, invalidMoves: [Move]) -> Move? {
        var bestMove : Move? = nil
        var bestScore = infinite
        for move in chessBoard.getPossibleMoves(color: .white) {
            if isInvalidMove(move, invalidMoves: invalidMoves) {
                continue
            }
            let copy = Board.clone(chessBoard: chessBoard)
            copy.performMove(move)
            let score = alphaBeta(chessBoard: copy, depth: 2, alpha: -infinite, beta: infinite, isMaximizing: true)
            if score < bestScore {
                bestScore = score
                bestMove = move
            }
        }
        
        //checking if this move will make the ai lose
        
        guard let aiMove = bestMove else {return bestMove}
        
        let copy = Board.clone(chessBoard: chessBoard)
        copy.performMove(aiMove)
        if copy.isCheck(color: .black) {
            var invalid = invalidMoves
            invalid.append(aiMove)
            return getAiMove(chessBoard: chessBoard, invalidMoves: invalid)
        }
        
        return bestMove
    }
    
    func isInvalidMove(_ move: Move, invalidMoves: [Move]) -> Bool {
        return invalidMoves.contains(move)
    }
}
