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
        if !isPositionInBounds(x: x, y: y) {
            return nil
        }
        return chessPieces[x][y]
    }
    
    class func clone(chessBoard: Board) -> Board{
        var chessPieces : [[Piece?]] = [[]]
        for i in 0...7 {
            chessPieces[i] = [Piece?](repeating: nil, count: 8)
        }
        for x in 0...7 {
            for y in 0...7 {
                let piece = chessBoard.chessPieces[x][y]
                if piece != nil {
                    chessPieces[x][y] = piece?.clone()
                }
            }
        }
        
        return Board(chessPieces: chessPieces, isWhiteKingMoved: chessBoard.isWhiteKingMoved, isBlackKingMoved: chessBoard.isBlackKingMoved)
    }
    
    func newChessBoard() -> Board{
        var chessPieces : [[Piece?]] = [[]]
        for i in 0...7 {
            chessPieces[i] = [Piece?](repeating: nil, count: 8)
        }
        
        //Pawns
        for x in 0...7 {
            chessPieces[x][8 - 2] = Pawn(x: x, y: 8 - 2, color: .white)
            chessPieces[x][1] = Pawn(x: x, y: 1, color: .black)
        }
        
        //Rocks
        chessPieces[0][8-1] = Rook(x: 0, y: 8-1, color: .white)
        chessPieces[8-1][8-1] = Rook(x: 8-1, y: 8-1, color: .white)
        chessPieces[0][0] = Rook(x: 0, y: 0, color: .black)
        chessPieces[8-1][0] = Rook(x: 8-1, y: 0, color: .black)

        //Knights
        chessPieces[1][8-1] = Knight(x: 1, y: 8-1, color: .white)
        chessPieces[8-2][8-1] = Knight(x: 8-2, y: 8-1, color: .white)
        chessPieces[1][0] = Knight(x: 1, y: 0, color: .black)
        chessPieces[8-2][0] = Knight(x: 8-2, y: 0, color: .black)
        
        //Bishops
        chessPieces[2][8-1] = Bishop(x: 2, y: 8-1, color: .white)
        chessPieces[8-3][8-1] = Bishop(x: 8-3, y: 8-1, color: .white)
        chessPieces[2][0] = Bishop(x: 2, y: 0, color: .black)
        chessPieces[8-3][0] = Bishop(x: 8-3, y: 0, color: .black)
        
        //King
        chessPieces[4][8-1] = King(x: 4, y: 8-1, color: .white)
        chessPieces[4][0] = King(x: 4, y: 0, color: .black)

        //Queen
        chessPieces[3][8-1] = Queen(x: 3, y: 8-1, color: .white)
        chessPieces[3][0] = Queen(x: 3, y: 0, color: .black)
        
        return Board(chessPieces: chessPieces, isWhiteKingMoved: false, isBlackKingMoved: false)
    }
    
    func getPossibleMoves(color: Color) -> [Move] {
        var moves : [Move] = []
        for x in 0...7 {
            for y in 0...7 {
                let piece = self.chessPieces[x][y]
                if piece != nil {
                    if piece!.color == color {
                        moves += piece!.getPossibleMoves(board: self)
                    }
                }
            }
        }
        return moves
    }
    
    func performMove(_ move: Move) {
        guard let piece = self.chessPieces[move.xFrom][move.yFrom] else {return}
        piece.x = move.xTo
        piece.y = move.yTo
        self.chessPieces[move.xTo][move.yTo] = piece
        self.chessPieces[move.xFrom][move.yFrom] = nil
        
        if piece.pieceType == .pawn {
            if piece.y == 0 || piece.y == 8-1 {
                self.chessPieces[piece.x][piece.y] = Queen(x: piece.x, y: piece.y, color: piece.color)
            }
        }
        
        if move.castlingMove {
            if move.xTo < move.xFrom {
                guard let rook = self.chessPieces[move.xFrom][0] else {return}
                rook.x = 2
                self.chessPieces[2][0] = rook
                self.chessPieces[0][0] = nil
                
            }
            if move.xTo > move.xFrom {
                guard let rook = self.chessPieces[move.xFrom][8-1] else {return}
                rook.x = 8 - 4
                self.chessPieces[8-4][0] = rook
                self.chessPieces[move.xFrom][8-1] = nil
                
            }
        }
        
        if piece.pieceType == .king {
            if piece.color == .white {
                self.isWhiteKingMoved = true
            } else {
                self.isBlackKingMoved = true
            }
        }
    }
    
    func isCheck(color: Color) -> Bool {
        var otherColor = Color.white
        if color == .white {
            otherColor = .black
        }
        
        var isKingFound = false
        
        for move in self.getPossibleMoves(color: otherColor) {
            let copy = Board.clone(chessBoard: self)
            copy.performMove(move)
            
            for x in 0...7 {
                for y in 0...7 {
                    let piece = copy.chessPieces[x][y]
                    if piece != nil {
                        if piece!.color == color && piece!.pieceType == .king {
                            isKingFound = true
                        }
                    }
                }
            }
        }
    return isKingFound
    }
}

