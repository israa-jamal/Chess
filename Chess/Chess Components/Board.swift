//
//  Board.swift
//  Chess
//
//  Created by Esraa Gamal on 22/03/2021.
//


import Foundation

class Board {
//    func copy(with zone: NSZone? = nil) -> Any {
//        let copy = Board(chessPieces: chessPieces, isWhiteKingMoved: isWhiteKingMoved, isBlackKingMoved: isBlackKingMoved)
//        return copy
//
//    }
    
    static let width = 8
    static let height = 8
    
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
    
         static func clone(chessBoard: Board) -> Board{
             var pieces : [[Piece?]] = Array(repeating: Array(), count: 8)
             for i in 0...7 {
                 pieces[i] = Array(repeating: nil, count: 8)
             }
             for x in 0...7 {
                 for y in 0...7 {
                     let piece = chessBoard.chessPieces[x][y]
                     if piece != nil {
                         pieces[x][y] = piece?.clone()
                     }
                 }
             }
     
             return Board(chessPieces: pieces, isWhiteKingMoved: chessBoard.isWhiteKingMoved, isBlackKingMoved: chessBoard.isBlackKingMoved)
         }
         

    class func newChessBoard() -> Board{
        var pieces : [[Piece?]] = Array(repeating: Array(), count: 8)
        for i in 0...7 {
            pieces[i] = Array(repeating: nil, count: 8)
        }
        
        //Pawns
        for x in 0...7 {
            pieces[x][height - 2] = Pawn(x: x, y: 8 - 2, color: .black)
            pieces[x][1] = Pawn(x: x, y: 1, color: .white)
        }
        
        //Rocks
        pieces[0][height-1] = Rook(x: 0, y: 8-1, color: .black)
        pieces[width-1][height-1] = Rook(x: 8-1, y: 8-1, color: .black)
        pieces[0][0] = Rook(x: 0, y: 0, color: .white)
        pieces[width-1][0] = Rook(x: 8-1, y: 0, color: .white)

        //Knights
        pieces[1][height-1] = Knight(x: 1, y: 8-1, color: .black)
        pieces[width-2][height-1] = Knight(x: 8-2, y: 8-1, color: .black)
        pieces[1][0] = Knight(x: 1, y: 0, color: .white)
        pieces[width-2][0] = Knight(x: 8-2, y: 0, color: .white)
        
        //Bishops
        pieces[2][height-1] = Bishop(x: 2, y: 8-1, color: .black)
        pieces[width-3][height-1] = Bishop(x: 8-3, y: 8-1, color: .black)
        pieces[2][0] = Bishop(x: 2, y: 0, color: .white)
        pieces[width-3][0] = Bishop(x: 8-3, y: 0, color: .white)
        
        //King
        pieces[4][height-1] = King(x: 4, y: 8-1, color: .black)
        pieces[4][0] = King(x: 4, y: 0, color: .white)

        //Queen
        pieces[3][height-1] = Queen(x: 3, y: 8-1, color: .black)
        pieces[3][0] = Queen(x: 3, y: 0, color: .white)
        
        return Board(chessPieces: pieces, isWhiteKingMoved: false, isBlackKingMoved: false)
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
    
    func performMove( _ move: Move, completion: ((Piece?)-> Void)? = nil, isDummyMove: Bool = true) {
        var dummyPiece : Piece?
        if isDummyMove {
            dummyPiece = self.chessPieces[move.xFrom][move.yFrom]?.copy() as? Piece
        } else {
            dummyPiece = self.chessPieces[move.xFrom][move.yFrom]
        }
        guard let piece = dummyPiece else {return}
        piece.x = move.xTo
        piece.y = move.yTo
        self.chessPieces[move.xTo][move.yTo] = piece
        self.chessPieces[move.xFrom][move.yFrom] = nil
        
        if piece.pieceType == .pawn {
            if piece.y == 0 || piece.y == Board.height-1 {
                self.chessPieces[piece.x][piece.y] = Queen(x: piece.x, y: piece.y, color: piece.color)
                let piece = self.chessPieces[piece.x][piece.y]
                completion?(piece)
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
                rook.x = Board.width - 4
                self.chessPieces[Board.width-4][0] = rook
                self.chessPieces[move.xFrom][Board.width-1] = nil
                
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
    return !isKingFound
    }
}


