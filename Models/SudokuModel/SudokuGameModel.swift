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
    func saveData(){
        //Using Realm
        for i in 0..<sudoku.getMatBoard().count{
            let sudokuElement = SudokuRow()
            sudokuElement.rowNumber = i
            sudokuElement.initialized = true
            for j in 0..<sudoku.getMatBoard()[i].count{
                sudokuElement.currentRow.append(sudoku.getMatBoard()[i][j])
            }
            do{
                try realm.write(){
                    realm.add(sudokuElement)
                }
                
            }catch{
                print("You did done fucked it")
            }
        }
        
    }
    func getColor(indexPath: IndexPath) -> CGColor{
        if (currentColorBeingUsedIndex % 3 == 0){
            if (currentColorBeingUsedIndex % 27 == 0) {
                indexCount = -1
                changeColorSelectionOrder = !changeColorSelectionOrder
            }
            if (changeColorSelectionOrder){
                indexCount+=1
            } else {
                indexCount-=1
            }
        }
        currentColorBeingUsedIndex+=1
        return colorsForEachSection[abs(indexCount%3)]
    }
    func didSelectItem(indexPath: IndexPath) {
        self.sudokuRowSelected = indexPath.row
        self.sudokuColumnSelected = indexPath.section
        indexCount = -1
        changeColorSelectionOrder = false
        // find all rows and columns that contains that number either from a possible value or the boxValue
        if (sudoku.checkSelectedState(row: sudokuRowSelected, column: sudokuColumnSelected, realm: realm) && sudoku.canHighlight(selectedRow: sudokuRowSelected, selectedColumn:sudokuColumnSelected)) {
            highlightedLocations = sudoku.highlightAllBoxesWithSameNumber(numberInBox: sudoku.getMatBoard()[sudokuRowSelected][sudokuColumnSelected].boxValue)
        } else {
            highlightedLocations = []
        }
    }
    func loadItems(){
        canidates = true
        if let sudokuGame = realm.objects(SudokuRow.self) as Results<SudokuRow>? {
            sudoku = Sudoku(previousBoard: sudokuGame, realm: realm)
        outerLoop: for i in 0..<sudoku.getMatBoard().count{
            for j in 0..<sudoku.getMatBoard()[i].count{
                if (sudoku.getMatBoard()[i][j].possibleValues.isEmpty && sudoku.getMatBoard()[i][j].isHidden &&     !sudoku.getMatBoard()[i][j].isSolved){
                    canidates = false
                    break outerLoop
                }
            }
        }
        }
    }
    func createNewGame(K: Int){
        do {
            try realm.write{
                realm.deleteAll()
            }
        } catch {
        }
        sudoku = Sudoku(numberOfMissingDigits: K)
        sudoku.fillValues();
        saveData()
    }
}
