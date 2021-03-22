//
//  Board.swift
//  Chess
//
//  Created by Esraa Gamal on 22/03/2021.
//


import Foundation

class Board {
    
    var chessPieces: [[Piece?]]
    var isWhiteKingMoved : Bool
    var isBlackKingMoved : Bool
    
    init(chessPieces: [[Piece?]], isWhiteKingMoved: Bool, isBlackKingMoved: Bool) {
        self.chessPieces = chessPieces
        self.isWhiteKingMoved = isWhiteKingMoved
        self.isBlackKingMoved = isBlackKingMoved
    }
    
    func isPositionInBounds(x: Int, y: Int) -> Bool {
        return (x >= 0 && y >= 0) && (x < 8 && y < 8)
    }
    func getPiece(x: Int, y: Int) -> Piece? {
        return Piece(x: x, y: y, color: .black, pieceType: .king, value: 0)
    }
    
}

