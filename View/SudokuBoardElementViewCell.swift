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
        if (color == .gray){
            self.sudokuLabel.font = UIFont.systemFont(ofSize: 10)
        } else {
            self.sudokuLabel.font = UIFont.systemFont(ofSize: 15)
        }
            
    }
    func setViewLabel(color: UIColor){
        collectionView?.backgroundColor = color
    }
}
