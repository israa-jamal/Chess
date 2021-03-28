//
//  King.swift
//  Chess
//
//  Created by Esraa Gamal on 28/03/2021.
//

import Foundation

class King : Piece {
    
    init(x: Int, y: Int, color: Color) {
        super.init(x: x, y: y, color: color, pieceType: .king, value: 20000)
    }
    
    override func getPossibleMoves(board: Board) -> [Move] {
        var moves : [Move?] = []

        moves.append(getMove(selfPiece: self, board: board, xTo: self.x+1, yTo: self.y))
        moves.append(getMove(selfPiece: self, board: board, xTo: self.x+1, yTo: self.y+1))
        moves.append(getMove(selfPiece: self, board: board, xTo: self.x, yTo: self.y+1))
        moves.append(getMove(selfPiece: self, board: board, xTo: self.x-1, yTo: self.y+1))
        moves.append(getMove(selfPiece: self, board: board, xTo: self.x-1, yTo: self.y))
        moves.append(getMove(selfPiece: self, board: board, xTo: self.x-1, yTo: self.y-1))
        moves.append(getMove(selfPiece: self, board: board, xTo: self.x, yTo: self.y-1))
        moves.append(getMove(selfPiece: self, board: board, xTo: self.x+1, yTo: self.y-1))
        
        moves.append(getTopCastlingMove(board: board))
        moves.append(getBottomCastlingMove(board: board))

        return removeNilFromList(moves)
    }
    
    func getTopCastlingMove(board: Board) -> Move? {
        if self.color == .white && board.isWhiteKingMoved {
            return nil
        }
        if self.color == .black && board.isBlackKingMoved {
            return nil
        }
        if let piece = board.getPiece(x: self.x, y: self.y-3) {
            if piece.color == self.color && piece.pieceType == .rook {
                if board.getPiece(x: self.x, y: self.y-1) == nil && board.getPiece(x: self.x, y: self.y-2) == nil {
                    return Move(xFrom: self.x, yFrom: self.y, xTo: self.x, yTo: self.y-2, castlingMove: true)
                }
            }
        }
        return nil
    }
    
    func getBottomCastlingMove(board: Board) -> Move? {
        if self.color == .white && board.isWhiteKingMoved {
            return nil
        }
        if self.color == .black && board.isBlackKingMoved {
            return nil
        }
        if let piece = board.getPiece(x: self.x, y: self.y+4) {
            if piece.color == self.color && piece.pieceType == .rook {
                if board.getPiece(x: self.x, y: self.y+1) == nil && board.getPiece(x: self.x, y: self.y+2) == nil && board.getPiece(x: self.x, y: self.y+3) == nil {
                    return Move(xFrom: self.x, yFrom: self.y, xTo: self.x, yTo: self.y+2, castlingMove: true)
                }
            }
        }
        return nil
    }
    
}
