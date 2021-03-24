//
//  Pieces.swift
//  Chess
//
//  Created by Esraa Gamal on 22/03/2021.
//

import Foundation

class Piece {
    var x : Int
    var y : Int
    var color : Color
    var pieceType : PieceType
    var value : Int

    init(x : Int, y : Int, color : Color, pieceType : PieceType, value : Int) {
        self.x = x
        self.y = y
        self.color = color
        self.pieceType = pieceType
        self.value = value
    }
    
    func getPossibleDiagonalMoves(selfPiece: Piece, board: Board) -> [Move] {
        var moves : [Move?] = []
        for i in 0...7 {
            if !board.isPositionInBounds(x: selfPiece.x+i, y: selfPiece.y+i) {
                break
            }
            let piece = board.getPiece(x: selfPiece.x+i, y: selfPiece.y+i)
            moves.append(getMove(selfPiece: selfPiece, board: board, xTo: selfPiece.x+i, yTo: selfPiece.y+i))
            if piece != nil {
                break
            }
        }
        
        for i in 0...7 {
            if !board.isPositionInBounds(x: selfPiece.x+i, y: selfPiece.y-i) {
                break
            }
            let piece = board.getPiece(x: selfPiece.x+i, y: selfPiece.y-i)
            moves.append(getMove(selfPiece: selfPiece, board: board, xTo: selfPiece.x+i, yTo: selfPiece.y-i))
            if piece != nil {
                break
            }
        }
        
        for i in 0...7 {
            if !board.isPositionInBounds(x: selfPiece.x-i, y: selfPiece.y-i) {
                break
            }
            let piece = board.getPiece(x: selfPiece.x-i, y: selfPiece.y-i)
            moves.append(getMove(selfPiece: selfPiece, board: board, xTo: selfPiece.x-i, yTo: selfPiece.y-i))
            if piece != nil {
                break
            }
        }
        
        for i in 0...7 {
            if !board.isPositionInBounds(x: selfPiece.x-i, y: selfPiece.y+i) {
                break
            }
            let piece = board.getPiece(x: selfPiece.x-i, y: selfPiece.y+i)
            moves.append(getMove(selfPiece: selfPiece, board: board, xTo: selfPiece.x-i, yTo: selfPiece.y+i))
            if piece != nil {
                break
            }
        }
        return removeNilFromList(moves)
    }
    
    func getPossibleHoriztontalAndVerticalMoves(selfPiece: Piece, board: Board) -> [Move] {
        var moves : [Move?] = []

        for i in 0...(8 - selfPiece.x) {
            let piece = board.getPiece(x: selfPiece.x+i, y: selfPiece.y)
            moves.append(getMove(selfPiece: selfPiece, board: board, xTo: selfPiece.x+i, yTo: selfPiece.y))
            if piece != nil {
                break
            }
        }
 
        for i in 0...(selfPiece.x + 1) {
            let piece = board.getPiece(x: selfPiece.x-i, y: selfPiece.y)
            moves.append(getMove(selfPiece: selfPiece, board: board, xTo: selfPiece.x-i, yTo: selfPiece.y))
            if piece != nil {
                break
            }
        }
    
        for i in 0...(8 - selfPiece.y) {
            let piece = board.getPiece(x: selfPiece.x, y: selfPiece.y+i)
            moves.append(getMove(selfPiece: selfPiece, board: board, xTo: selfPiece.x, yTo: selfPiece.y+i))
            if piece != nil {
                break
            }
        }

        for i in 0...(selfPiece.y + 1) {
            let piece = board.getPiece(x: selfPiece.x, y: selfPiece.y-i)
            moves.append(getMove(selfPiece: selfPiece, board: board, xTo: selfPiece.x, yTo: selfPiece.y-i))
            if piece != nil {
                break
            }
        }
        
        return removeNilFromList(moves)
       
    }
    
    func removeNilFromList(_ moves: [Move?]) -> [Move] {
        return moves.filter{$0 != nil}.map{move in return move!}
    }
    
    func getMove(selfPiece: Piece, board: Board, xTo: Int, yTo: Int) -> Move? {
        var move : Move?
        if board.isPositionInBounds(x: xTo, y: yTo) {
            let piece = board.getPiece(x: xTo, y: yTo)
            if piece != nil {
                if piece!.color != selfPiece.color {
                    move = Move(xFrom: selfPiece.x, yFrom: selfPiece.y, xTo: xTo, yTo: yTo, castlingMove: false)
                }
            } else {
                move = Move(xFrom: selfPiece.x, yFrom: selfPiece.y, xTo: xTo, yTo: yTo, castlingMove: false)
            }
        }
        return move
    }
    
    func getPossibleMoves(board: Board) -> [Move] {
        return []
    }
    
    func clone() -> Piece{
        return self
    }
    
    func getPieceImageName() -> String{
        return self.color.rawValue + self.pieceType.rawValue
    }
}

class Bishop : Piece {
    
    init(x: Int, y: Int, color: Color) {
        super.init(x: x, y: y, color: color, pieceType: .bishop, value: 330)
    }
    
    override func getPossibleMoves(board: Board) -> [Move] {
        return getPossibleDiagonalMoves(selfPiece: self, board: board)
    }
    
}

class Rook : Piece {
    
    init(x: Int, y: Int, color: Color) {
        super.init(x: x, y: y, color: color, pieceType: .rook, value: 500)
    }
    
    override func getPossibleMoves(board: Board) -> [Move] {
        return getPossibleHoriztontalAndVerticalMoves(selfPiece: self, board: board)
    }
    
}

class Queen : Piece {
    
    init(x: Int, y: Int, color: Color) {
        super.init(x: x, y: y, color: color, pieceType: .queen, value: 900)
    }
    
    override func getPossibleMoves(board: Board) -> [Move] {
        return getPossibleDiagonalMoves(selfPiece: self, board: board) + getPossibleHoriztontalAndVerticalMoves(selfPiece: self, board: board)
    }
    
}

class Knight : Piece {
    
    init(x: Int, y: Int, color: Color) {
        super.init(x: x, y: y, color: color, pieceType: .knight, value: 320)
    }
    
    override func getPossibleMoves(board: Board) -> [Move] {
        var moves : [Move?] = []
        moves.append(getMove(selfPiece: self, board: board, xTo: self.x+2, yTo: self.y+1))
        moves.append(getMove(selfPiece: self, board: board, xTo: self.x-1, yTo: self.y+1))
        moves.append(getMove(selfPiece: self, board: board, xTo: self.x-2, yTo: self.y+1))
        moves.append(getMove(selfPiece: self, board: board, xTo: self.x+1, yTo: self.y-2))
        moves.append(getMove(selfPiece: self, board: board, xTo: self.x+2, yTo: self.y-1))
        moves.append(getMove(selfPiece: self, board: board, xTo: self.x+1, yTo: self.y+2))
        moves.append(getMove(selfPiece: self, board: board, xTo: self.x-2, yTo: self.y-1))
        moves.append(getMove(selfPiece: self, board: board, xTo: self.x-1, yTo: self.y-2))

        return removeNilFromList(moves)
    }
    
}

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

enum Color : String{
    case white = "w"
    case black = "b"
}

enum PieceType : String{
    case king = "K"
    case queen = "Q"
    case knight = "N"
    case rook = "R"
    case pawn = "P"
    case bishop = "B"
}

class Move: Equatable {
    static func == (lhs: Move, rhs: Move) -> Bool {
        return lhs.xFrom == rhs.xFrom && lhs.xTo == rhs.xTo && lhs.yFrom == rhs.yFrom && lhs.yTo == rhs.yTo && lhs.castlingMove == rhs.castlingMove
    }
    
    var xFrom : Int
    var yFrom : Int
    var xTo : Int
    var yTo : Int
    var castlingMove : Bool
    
    init(xFrom : Int, yFrom : Int, xTo : Int, yTo : Int, castlingMove : Bool) {
        self.xFrom = xFrom
        self.yFrom = yFrom
        self.xTo = xTo
        self.yTo = yTo
        self.castlingMove = castlingMove
    }
    
}
