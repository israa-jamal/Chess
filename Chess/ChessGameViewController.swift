//
//  ChessGame.swift
//  Chess
//
//  Created by Esraa Gamal on 23/03/2021.
//

import Cocoa

enum PlayCase{
    case PickPiece
    case ChooseMove
    case PickAnotherPiece
    case none
}

class ChessGameViewController: NSViewController {
    
    @IBOutlet weak var chessBoardCollectionView: NSCollectionView!
    
    var board : Board?
    var previousSelectedItemIndexPath : IndexPath?
    var previousMovesIndices : [IndexPath] = []
    var currentSelectedPiece : Piece?
    var playCase = PlayCase.PickPiece
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureChessBoardCollectionView()
        board = Board.newChessBoard()
    }
    
    func configureChessBoardCollectionView() {
        chessBoardCollectionView.register(NSNib.init(nibNamed: K.boardSquareItem, bundle: nil), forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: K.boardSquareItem))
        configureCollectionViewFlow()
    }
    
    func configureCollectionViewFlow() {
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.itemSize = NSSize(width: 80, height: 80)
        chessBoardCollectionView.collectionViewLayout = flowLayout
    }
}

//MARK:- ChessBoard NSCollectionView

extension ChessGameViewController : NSCollectionViewDataSource, NSCollectionViewDelegate {
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return Board.height
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return Board.width
    }
    
    func collectionView(_ itemForRepresentedObjectAtcollectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = chessBoardCollectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: K.boardSquareItem), for: indexPath) as! ChessSquare
        item.contentView.backgroundColor = getColorForCell(indexPath: indexPath)
        if board != nil {
            if let piece = board!.chessPieces[indexPath.item][indexPath.section] {
                item.updateCell(with: piece)
            }
        }
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first else {return}
        guard let cell = collectionView.item(at: indexPath) as? ChessSquare else {return}
        setPlayingCase(indexPath: indexPath)
        
        switch playCase {
        case .PickPiece:
            // change background
            cell.contentView.backgroundColor = NSColor.clear
            //show moves for this piece and store them
            showPossibleMoves(indexPath: indexPath)
            //store move and previous selected pieces
            self.previousSelectedItemIndexPath = indexPath
        case .ChooseMove:
            makeMove(indexPath: indexPath)
            handlePreviouslySelectedItems()
        case .PickAnotherPiece:
            handlePreviouslySelectedItems()
            cell.contentView.backgroundColor = NSColor.clear
            showPossibleMoves(indexPath: indexPath)
            self.previousSelectedItemIndexPath = indexPath
        case .none:
            return
        }
        
    }
    
    //MARK: Helpers
    
    func getColorForCell(indexPath: IndexPath) -> NSColor? {
        if indexPath.section % 2 != 0 {
            if indexPath.item % 2 == 0 {
                return NSColor(named: K.darkBrownColor)
            } else {
                return NSColor(named: K.lightBrownColor)
                
            }
        } else {
            if indexPath.item % 2 != 0 {
                return NSColor(named: K.darkBrownColor)
            } else {
                return NSColor(named: K.lightBrownColor)
                
            }
        }
    }
    
    func handlePreviouslySelectedItems() {
        if self.previousSelectedItemIndexPath != nil {
            guard let cell = chessBoardCollectionView.item(at: previousSelectedItemIndexPath!) as? ChessSquare else {return}
            cell.contentView.backgroundColor = getColorForCell(indexPath: previousSelectedItemIndexPath!)
            self.previousSelectedItemIndexPath = nil
            self.currentSelectedPiece = nil
        }
        
        for move in previousMovesIndices {
            guard let cell = chessBoardCollectionView.item(at: move) as? ChessSquare else {return}
            cell.contentView.backgroundColor = getColorForCell(indexPath: move)
        }
        self.previousMovesIndices.removeAll()
    }
    
    func showPossibleMoves(indexPath: IndexPath) {
        guard let board = self.board else {return}
        guard let piece = board.getPiece(x: indexPath.item, y: indexPath.section) else {return}
        self.currentSelectedPiece = piece
        let moves = piece.getPossibleMoves(board: board)
        for move in moves {
            let moveIndexPath = IndexPath(item: move.xTo, section: move.yTo)
            guard let cell = chessBoardCollectionView.item(at: moveIndexPath) as? ChessSquare else {return}
            cell.contentView.backgroundColor = NSColor(named: K.selectedColor)
            previousMovesIndices.append(moveIndexPath)
        }
    }
    
    func setPlayingCase(indexPath: IndexPath) {
        guard let cell = chessBoardCollectionView.item(at: indexPath) as? ChessSquare else {return}

        if cell.piece != nil {
            if cell.piece!.color == .white{
                if previousMovesIndices.contains(indexPath) {
                    self.playCase = .ChooseMove
                } else {
                    self.playCase = .none
                }
            } else {
                if previousSelectedItemIndexPath == nil {
                    self.playCase = .PickPiece
                } else {
                    self.playCase = .PickAnotherPiece
                }
            }
        } else {
            if previousMovesIndices.contains(indexPath) {
                self.playCase = .ChooseMove
            } else {
                self.playCase = .none
            }
        }
    }
    
    func makeMove(indexPath: IndexPath) {
        guard let piece = self.currentSelectedPiece else {return}
        guard let previousIndex = self.previousSelectedItemIndexPath else {return}
        guard let cell = chessBoardCollectionView.item(at: indexPath) as? ChessSquare else {return}
        guard let previousCell = chessBoardCollectionView.item(at: previousIndex) as? ChessSquare else {return}

        board?.performMove(Move(xFrom: piece.x, yFrom: piece.y, xTo: indexPath.item, yTo: indexPath.section, castlingMove: false))
        
            cell.updateCell(with: previousCell.piece)
            previousCell.updateCell(with: nil)
    }
}

