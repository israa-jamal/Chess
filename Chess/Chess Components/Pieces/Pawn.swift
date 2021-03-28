//
//  Pawn.swift
//  Chess
//
//  Created by Esraa Gamal on 28/03/2021.
//

import Foundation

class Pawn : Piece {
    
    init(x: Int, y: Int, color: Color) {
        super.init(x: x, y: y, color: color, pieceType: .pawn, value: 100)
    }
    
    override func getPossibleMoves(board: Board) -> [Move] {
        var moves : [Move?] = []
        var direction = -1
        if self.color == .white {
            direction = 1
        }
        if board.getPiece(x: self.x, y: self.y+direction) == nil {
            moves.append(getMove(selfPiece: self, board: board, xTo: self.x, yTo: self.y+direction))
        }
        if self.isStartingPosition() && board.getPiece(x: self.x, y: self.y+direction) == nil && board.getPiece(x: self.x, y: self.y+(direction*2)) == nil {
            moves.append(getMove(selfPiece: self, board: board, xTo: self.x, yTo: self.y+(direction*2)))
        }
        
        var piece = board.getPiece(x: self.x+1, y: self.y+direction)
        if piece != nil {
            moves.append(getMove(selfPiece: self, board: board, xTo: self.x+1, yTo: self.y+direction))
        }
        piece = board.getPiece(x: self.x-1, y: self.y+direction)
        if piece != nil {
            moves.append(getMove(selfPiece: self, board: board, xTo: self.x-1, yTo: self.y+direction))
        }
        return removeNilFromList(moves)
    }
    
    func isStartingPosition() -> Bool {
        if self.color == .white {
            return self.y == 1
        } else {
            return self.y == 8 - 2
        }
    }
    
}
