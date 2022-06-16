//
//  SudokuCollectionViewCell.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 6/2/22.
//

import UIKit

class SudokuBoardElementViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sudokuLabel: UILabel!
    @IBOutlet weak var collectionView: UIView!

    
    func setLabel(sudokuLabel:String) {
        self.sudokuLabel?.text = sudokuLabel
    }
    func setLabelColor(color: UIColor){
            sudokuLabel?.textColor = color
    }
    func setViewLabel(color: UIColor){
        collectionView?.backgroundColor = color
    }
}
