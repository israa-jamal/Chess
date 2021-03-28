//
//  ChessSqaure.swift
//  Chess
//
//  Created by Esraa Gamal on 23/03/2021.
//

import Cocoa

class ChessSquare: NSCollectionViewItem {

    @IBOutlet weak var chessPiece: NSImageView!
    @IBOutlet weak var contentView: MyView!
    
    var piece: Piece?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.backgroundColor = NSColor(named: K.darkBrownColor)
    }
    
    func updateCell(with piece: Piece?) {
        self.piece = piece
        var imageView : NSImage? = nil
        if piece != nil {
            let imageName = piece!.getPieceImageName()
            imageView = NSImage(named: imageName)
        }
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.75
            chessPiece.animator().image = imageView
        })
    }
}
