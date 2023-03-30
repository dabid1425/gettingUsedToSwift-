//
//  SudokuGameModel.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 3/27/23.
//

import Foundation
import UIKit
import RealmSwift
class SudokuGameModel {
    var newGame:Bool = false
    var changeColorSelectionOrder:Bool = false
    var pencilSelected:Bool = false
    var currentColorBeingUsedIndex: Int = 0
    let realm = try! Realm()
    var canidates:Bool = false
    var indexCount:Int = -1
    var highlightedLocations:[Highlight] = []
    let colorsForEachSection:[CGColor] = [ UIColor.red.cgColor,UIColor.black.cgColor,UIColor.blue.cgColor]
    var sudoku: Sudoku!;
    var screenSize : CGRect!
    var screenWidth : CGFloat!
    var screenHeight : CGFloat!
    var sudokuRowSelected: Int = -1
    var sudokuColumnSelected: Int = -1
    let alphaHalf: CGFloat = 0.5
    let alphaFull: CGFloat = 1.0
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var sudokuGame: Results<SudokuRow>?
}
