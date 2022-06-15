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
    
    func setLabel(label:String) {
        if (!sudokuLabel.isHidden){
            sudokuLabel?.text = label
        } else {
            hints?.text = label
        }
    }
    
    func changeLabelView(possibleValues: Bool){
        sudokuLabel.isHidden = !possibleValues
        hints.isHidden = possibleValues
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
