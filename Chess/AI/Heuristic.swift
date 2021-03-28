//
//  Heuristic.swift
//  Chess
//
//  Created by Esraa Gamal on 28/03/2021.
//

import Foundation

class Heuristic {
    
    //MARK:- Transition Tables
    
    static let shared = Heuristic()
    
    let pawnTable = [
        [ 0,  0,  0,  0,  0,  0,  0,  0],
        [50, 50, 50, 50, 50, 50, 50, 50],
        [10, 10, 20, 30, 30, 20, 10, 10],
        [ 5,  5, 10, 25, 25, 10,  5,  5],
        [ 0,  0,  0, 20, 20,  0,  0,  0],
        [ 5, -5,-10,  0,  0,-10, -5,  5],
        [ 5, 10, 10,-20,-20, 10, 10,  5],
        [ 0,  0,  0,  0,  0,  0,  0,  0]
    ]
    let knightTable = [
        [-50, -40, -30, -30, -30, -30, -40, -50],
        [-40, -20,   0,   0,   0,   0, -20, -40],
        [-30,   0,  10,  15,  15,  10,   0, -30],
        [-30,   5,  15,  20,  20,  15,   0, -30],
        [-30,   0,  15,  20,  20,  15,   0, -30],
        [-30,   5,  10,  15,  15,  10,   5, -30],
        [-40, -20,   0,   5,   5,   0, -20, -40],
        [-50, -40, -30, -30, -30, -30, -40, -50]
    ]
    
    let bishopTable = [
        [-20, -10, -10, -10, -10, -10, -10, -20],
        [-10,   0,   0,   0,   0,   0,   0, -10],
        [-10,   0,   5,  10,  10,   5,   0, -10],
        [-10,   5,   5,  10,  10,   5,   5, -10],
        [-10,   0,  10,  10,  10,  10,   0, -10],
        [-10,  10,  10,  10,  10,  10,  10, -10],
        [-10,   5,   0,   0,   0,   0,   5, -10],
        [-20, -10, -10, -10, -10, -10, -10, -20]
    ]
    
    let rookTable = [
        [ 0,  0,  0,  0,  0,  0,  0,  0],
        [ 5, 10, 10, 10, 10, 10, 10,  5],
        [-5,  0,  0,  0,  0,  0,  0, -5],
        [-5,  0,  0,  0,  0,  0,  0, -5],
        [-5,  0,  0,  0,  0,  0,  0, -5],
        [-5,  0,  0,  0,  0,  0,  0, -5],
        [-5,  0,  0,  0,  0,  0,  0, -5],
        [ 0,  0,  0,  5,  5,  0,  0,  0]
    ]
    
    let queenTable = [
        [-20, -10, -10, -5, -5, -10, -10, -20],
        [-10,   0,   0,  0,  0,   0,   0, -10],
        [-10,   0,   5,  5,  5,   5,   0, -10],
        [ -5,   0,   5,  5,  5,   5,   0,  -5],
        [  0,   0,   5,  5,  5,   5,   0,  -5],
        [-10,   5,   5,  5,  5,   5,   0, -10],
        [-10,   0,   5,  0,  0,   0,   0, -10],
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
