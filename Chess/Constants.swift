//
//  Constants.swift
//  Chess
//
//  Created by Esraa Gamal on 23/03/2021.
//

import Foundation

struct K {
    static let darkBrownColor = "DarkBoardColor"
    static let lightBrownColor = "LightBoardColor"
    static let boardSquareItem = "ChessSquare"
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
