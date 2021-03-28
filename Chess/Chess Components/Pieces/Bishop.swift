//
//  Bishop.swift
//  Chess
//
//  Created by Esraa Gamal on 28/03/2021.
//

import Foundation

class Bishop : Piece {
    
    init(x: Int, y: Int, color: Color) {
        super.init(x: x, y: y, color: color, pieceType: .bishop, value: 330)
    }
    
    override func getPossibleMoves(board: Board) -> [Move] {
        return getPossibleDiagonalMoves(selfPiece: self, board: board)
    }
    
}
