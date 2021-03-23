//
//  ChessGame.swift
//  Chess
//
//  Created by Esraa Gamal on 23/03/2021.
//

import Cocoa

class ChessGame: NSViewController {

    @IBOutlet weak var chessBoardCollectionView: NSCollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chessBoardCollectionView.register(NSNib.init(nibNamed: "ChessSquare", bundle: nil), forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ChessSquare"))
    }
    
}
extension ChessGame : NSCollectionViewDataSource {
  
  func numberOfSections(in collectionView: NSCollectionView) -> Int {
    return 8
  }
  

  func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    return 8
  }
  
  func collectionView(_ itemForRepresentedObjectAtcollectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    

    let item = chessBoardCollectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ChessSquare"), for: indexPath) as! ChessSquare
    item.chessPiece.image = NSImage(named: "wK")
    return item
  }
  
}
