//
//  AI.swift
//  Chess
//
//  Created by Esraa Gamal on 22/03/2021.
//

import Foundation

class Heuristic {
    
    //MARK:- Transition Tables
    
    static let shared = Heuristic()
    
    let pawnTable = [
        [ 0,  0,  0,  0,  0,  0,  0,  0],
        [ 5, 10, 10,-20,-20, 10, 10,  5],
        [ 5, -5,-10,  0,  0,-10, -5,  5],
        [ 0,  0,  0, 20, 20,  0,  0,  0],
        [ 5,  5, 10, 25, 25, 10,  5,  5],
        [10, 10, 20, 30, 30, 20, 10, 10],
        [50, 50, 50, 50, 50, 50, 50, 50],
        [ 0,  0,  0,  0,  0,  0,  0,  0]
    ]
    let knightTable = [
        [-50, -40, -30, -30, -30, -30, -40, -50],
        [-40, -20,   0,   5,   5,   0, -20, -40],
        [-30,   5,  10,  15,  15,  10,   5, -30],
        [-30,   0,  15,  20,  20,  15,   0, -30],
        [-30,   5,  15,  20,  20,  15,   0, -30],
        [-30,   0,  10,  15,  15,  10,   0, -30],
        [-40, -20,   0,   0,   0,   0, -20, -40],
        [-50, -40, -30, -30, -30, -30, -40, -50]
    ]
    
    let bishopTable = [
        [-20, -10, -10, -10, -10, -10, -10, -20],
        [-10,   5,   0,   0,   0,   0,   5, -10],
        [-10,  10,  10,  10,  10,  10,  10, -10],
        [-10,   0,  10,  10,  10,  10,   0, -10],
        [-10,   5,   5,  10,  10,   5,   5, -10],
        [-10,   0,   5,  10,  10,   5,   0, -10],
        [-10,   0,   0,   0,   0,   0,   0, -10],
        [-20, -10, -10, -10, -10, -10, -10, -20]
    ]
    
    let rookTable = [
        [ 0,  0,  0,  5,  5,  0,  0,  0],
        [-5,  0,  0,  0,  0,  0,  0, -5],
        [-5,  0,  0,  0,  0,  0,  0, -5],
        [-5,  0,  0,  0,  0,  0,  0, -5],
        [-5,  0,  0,  0,  0,  0,  0, -5],
        [-5,  0,  0,  0,  0,  0,  0, -5],
        [ 5, 10, 10, 10, 10, 10, 10,  5],
        [ 0,  0,  0,  0,  0,  0,  0,  0]
    ]
    
    let queenTable = [
        [-20, -10, -10, -5, -5, -10, -10, -20],
        [-10,   0,   5,  0,  0,   0,   0, -10],
        [-10,   5,   5,  5,  5,   5,   0, -10],
        [  0,   0,   5,  5,  5,   5,   0,  -5],
        [ -5,   0,   5,  5,  5,   5,   0,  -5],
        [-10,   0,   5,  5,  5,   5,   0, -10],
        [-10,   0,   0,  0,  0,   0,   0, -10],
        [-20, -10, -10, -5, -5, -10, -10, -20]
    ]
    
    //MARK:- Heuristic Evaluation
    
    func evaluate(board: Board) -> Int{
        let material = getMaterialScore(board: board)
    
        let pawns = getPiecePositionScore(board: board, pieceType: .pawn, table: pawnTable)
        let knights = getPiecePositionScore(board: board, pieceType: .knight, table: knightTable)
        let bishops = getPiecePositionScore(board: board, pieceType: .bishop, table: bishopTable)
        let rooks = getPiecePositionScore(board: board, pieceType: .rook, table: rookTable)
        let queens = getPiecePositionScore(board: board, pieceType: .queen, table: queenTable)
        
        return material + pawns + knights + bishops + rooks + queens
    }
    
    func getPiecePositionScore(board: Board, pieceType: PieceType, table: [[Int]]) -> Int{
        var white = 0
        var black = 0
        for x in 0...7 {
            for y in 0...7 {
                if let piece = board.chessPieces[x][y] {
                    if piece.pieceType == pieceType {
                        if piece.color == .white {
                            white += table[x][y]
                        } else {
                            black += table[7-x][y]
                        }
                    }
                }
            }
        }
        return white - black
    }
    
    func getMaterialScore(board: Board) -> Int{
        var white = 0
        var black = 0
        for x in 0...7 {
            for y in 0...7 {
                if let piece = board.chessPieces[x][y] {
                    if piece.color == .white {
                        white += piece.value
                    } else {
                        black += piece.value
                    }
                }
            }
        }
        return white - black
      
    }
}

class AI {
        
    static let shared = AI()
    let infinite = 10000000
    
    
    func alphaBeta(chessBoard: Board, depth: Int, alpha: Int, beta: Int, isMaximizing: Bool) -> Int{
        
        //Root
        if depth == 0 {
            return Heuristic.shared.evaluate(board: chessBoard)
        }
        
        if isMaximizing {
            var bestScore = infinite
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
        for move in chessBoard.getPossibleMoves(color: .black) {
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
