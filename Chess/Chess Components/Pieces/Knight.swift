//
//  Knight.swift
//  Chess
//
//  Created by Esraa Gamal on 28/03/2021.
//

import Foundation

class Knight : Piece {
    
    init(x: Int, y: Int, color: Color) {
        super.init(x: x, y: y, color: color, pieceType: .knight, value: 320)
    }
 
    override func getPossibleMoves(board: Board) -> [Move] {
        var moves : [Move?] = []
        moves.append(getMove(selfPiece: self, board: board, xTo: self.x+2, yTo: self.y+1))
        moves.append(getMove(selfPiece: self, board: board, xTo: self.x-1, yTo: self.y+2))
        moves.append(getMove(selfPiece: self, board: board, xTo: self.x-2, yTo: self.y+1))
        moves.append(getMove(selfPiece: self, board: board, xTo: self.x+1, yTo: self.y-2))
        moves.append(getMove(selfPiece: self, board: board, xTo: self.x+2, yTo: self.y-1))
        moves.append(getMove(selfPiece: self, board: board, xTo: self.x+1, yTo: self.y+2))
        moves.append(getMove(selfPiece: self, board: board, xTo: self.x-2, yTo: self.y-1))
        moves.append(getMove(selfPiece: self, board: board, xTo: self.x-1, yTo: self.y-2))

        return removeNilFromList(moves)
    }
    
}
