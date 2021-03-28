//
//  Rook.swift
//  Chess
//
//  Created by Esraa Gamal on 28/03/2021.
//

import Foundation

class Rook : Piece {
    
    init(x: Int, y: Int, color: Color) {
        super.init(x: x, y: y, color: color, pieceType: .rook, value: 500)
    }
    
    override func getPossibleMoves(board: Board) -> [Move] {
        return getPossibleHoriztontalAndVerticalMoves(selfPiece: self, board: board)
    }
    
}
