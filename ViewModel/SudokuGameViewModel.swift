//
//  SudokuGameViewModel.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 3/30/23.
//

import Foundation
import CoreGraphics
import RealmSwift
class SudokuGameViewModel {
    var sudokuGameModel = SudokuGameModel()
    func saveData(){
        //Using Realm
        for i in 0..<sudokuGameModel.sudoku.getMatBoard().count{
            let sudokuElement = SudokuRow()
            sudokuElement.rowNumber = i
            sudokuElement.initialized = true
            for j in 0..<sudokuGameModel.sudoku.getMatBoard()[i].count{
                sudokuElement.currentRow.append(sudokuGameModel.sudoku.getMatBoard()[i][j])
            }
            do{
                try sudokuGameModel.realm.write(){
                    sudokuGameModel.realm.add(sudokuElement)
                }
                
            }catch{
                print("You did done fucked it")
            }
        }
        
    }
    func getColor(indexPath: IndexPath) -> CGColor{
        if (sudokuGameModel.currentColorBeingUsedIndex % 3 == 0){
            if (sudokuGameModel.currentColorBeingUsedIndex % 27 == 0) {
                sudokuGameModel.indexCount = -1
                sudokuGameModel.changeColorSelectionOrder = !sudokuGameModel.changeColorSelectionOrder
            }
            if (sudokuGameModel.changeColorSelectionOrder){
                sudokuGameModel.indexCount+=1
            } else {
                sudokuGameModel.indexCount-=1
            }
        }
        sudokuGameModel.currentColorBeingUsedIndex+=1
        return sudokuGameModel.colorsForEachSection[abs(sudokuGameModel.indexCount%3)]
    }
    func didSelectItem(indexPath: IndexPath) {
        self.sudokuGameModel.sudokuRowSelected = indexPath.row
        self.sudokuGameModel.sudokuColumnSelected = indexPath.section
        sudokuGameModel.indexCount = -1
        sudokuGameModel.changeColorSelectionOrder = false
        // find all rows and columns that contains that number either from a possible value or the boxValue
        if (sudokuGameModel.sudoku.checkSelectedState(row: sudokuGameModel.sudokuRowSelected, column: sudokuGameModel.sudokuColumnSelected, realm: sudokuGameModel.realm) && sudokuGameModel.sudoku.canHighlight(selectedRow: sudokuGameModel.sudokuRowSelected, selectedColumn: sudokuGameModel.sudokuColumnSelected)) {
            sudokuGameModel.highlightedLocations = sudokuGameModel.sudoku.highlightAllBoxesWithSameNumber(numberInBox: sudokuGameModel.sudoku.getMatBoard()[sudokuGameModel.sudokuRowSelected][sudokuGameModel.sudokuColumnSelected].boxValue)
        } else {
            sudokuGameModel.highlightedLocations = []
        }
    }
    func loadItems(){
        sudokuGameModel.canidates = true
        if let sudokuGame = sudokuGameModel.realm.objects(SudokuRow.self) as Results<SudokuRow>? {
            sudokuGameModel.sudoku = Sudoku(previousBoard: sudokuGame, realm: sudokuGameModel.realm)
        outerLoop: for i in 0..<sudokuGameModel.sudoku.getMatBoard().count{
            for j in 0..<sudokuGameModel.sudoku.getMatBoard()[i].count{
                if (sudokuGameModel.sudoku.getMatBoard()[i][j].possibleValues.isEmpty && sudokuGameModel.sudoku.getMatBoard()[i][j].isHidden &&     !sudokuGameModel.sudoku.getMatBoard()[i][j].isSolved){
                    sudokuGameModel.canidates = false
                    break outerLoop
                }
            }
        }
        }
    }
    func createNewGame(K: Int){
        do {
            try sudokuGameModel.realm.write{
                sudokuGameModel.realm.deleteAll()
            }
        } catch {
        }
        sudokuGameModel.sudoku = Sudoku(numberOfMissingDigits: K)
        sudokuGameModel.sudoku.fillValues();
        saveData()
    }
}
