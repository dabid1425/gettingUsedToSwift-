//
//  SudokuCollectionViewCell.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 6/2/22.
//

import UIKit

class SudokuBoardElementViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sudokuLabel: UILabel!
    
    func setLabel(label:String) {
        sudokuLabel?.text = label
    }
    func setAlphaValue(alphaValue: CGFloat){
        sudokuLabel?.alpha = alphaValue
    }
}
