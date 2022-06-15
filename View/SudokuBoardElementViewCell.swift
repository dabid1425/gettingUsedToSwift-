//
//  SudokuCollectionViewCell.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 6/2/22.
//

import UIKit

class SudokuBoardElementViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sudokuLabel: UILabel!
    @IBOutlet weak var hints: UILabel!
    @IBOutlet weak var collectionView: UIView!
    
    func setLabel(sudokuLabel:String,hints:String) {
        self.sudokuLabel?.text = sudokuLabel
        self.hints?.text = hints
    }
    func setLabelColor(color: UIColor){
        if (!sudokuLabel.isHidden){
            sudokuLabel?.textColor = color
        } else {
            hints.textColor = color
        }
    }
    func setViewLabel(color: UIColor){
        collectionView?.backgroundColor = color
    }
}
