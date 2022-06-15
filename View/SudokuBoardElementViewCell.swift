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
    
    func setLabel(label:String) {
        sudokuLabel?.text = label
    }
    func setAlphaValue(alphaValue: CGFloat){
        sudokuLabel?.alpha = alphaValue
    }
    func setLabelColor(color: UIColor){
        sudokuLabel?.textColor = color
    }
    func setViewLabel(color: UIColor){
        collectionView?.backgroundColor = color
        if (color == .white){
            isSelected = false
        }
    }
    func setSelectValue()  {
        isSelected = !isSelected
    }
    func getSelected() -> Bool {
        return isSelected
    }
}
