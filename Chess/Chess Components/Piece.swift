//
//  Pieces.swift
//  Chess
//
//  Created by Esraa Gamal on 22/03/2021.
//

import Foundation

class Piece : NSCopying{
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Piece(x: x, y: y, color: color, pieceType: pieceType, value: value)
        return copy
    }
    
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
        for i in 1...8 {
            if !board.isPositionInBounds(x: selfPiece.x+i, y: selfPiece.y+i) {
                break
            }
            let piece = board.getPiece(x: selfPiece.x+i, y: selfPiece.y+i)
            moves.append(getMove(selfPiece: selfPiece, board: board, xTo: selfPiece.x+i, yTo: selfPiece.y+i))
            if piece != nil {
                break
            }
        }

        for i in 1...8 {
            if !board.isPositionInBounds(x: selfPiece.x+i, y: selfPiece.y-i) {
                break
            }
            let piece = board.getPiece(x: selfPiece.x+i, y: selfPiece.y-i)
            moves.append(getMove(selfPiece: selfPiece, board: board, xTo: selfPiece.x+i, yTo: selfPiece.y-i))
            if piece != nil {
                break
            }
        }
        
        for i in 1...8 {
            if !board.isPositionInBounds(x: selfPiece.x-i, y: selfPiece.y-i) {
                break
            }
            let piece = board.getPiece(x: selfPiece.x-i, y: selfPiece.y-i)
            moves.append(getMove(selfPiece: selfPiece, board: board, xTo: selfPiece.x-i, yTo: selfPiece.y-i))
            if piece != nil {
                break
            }
        }
        
        for i in 1...8 {
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

        for i in 1...(8 - selfPiece.x) {
            let piece = board.getPiece(x: selfPiece.x+i, y: selfPiece.y)
            moves.append(getMove(selfPiece: selfPiece, board: board, xTo: selfPiece.x+i, yTo: selfPiece.y))
            if piece != nil {
                break
            }
        }
 
        for i in 1...(selfPiece.x + 1) {
            let piece = board.getPiece(x: selfPiece.x-i, y: selfPiece.y)
            moves.append(getMove(selfPiece: selfPiece, board: board, xTo: selfPiece.x-i, yTo: selfPiece.y))
            if piece != nil {
                break
            }
        }
    
        for i in 1...(8 - selfPiece.y) {
            let piece = board.getPiece(x: selfPiece.x, y: selfPiece.y+i)
            moves.append(getMove(selfPiece: selfPiece, board: board, xTo: selfPiece.x, yTo: selfPiece.y+i))
            if piece != nil {
                break
            }
        }

        for i in 1...(selfPiece.y + 1) {
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

//MARK:- class Move

class Move: Equatable {
    static func == (lhs: Move, rhs: Move) -> Bool {
        return lhs.xFrom == rhs.xFrom && lhs.xTo == rhs.xTo && lhs.yFrom == rhs.yFrom && lhs.yTo == rhs.yTo
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
