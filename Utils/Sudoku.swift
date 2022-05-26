//
//  Sudoku.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 5/23/22.
//

import Foundation

class Sudoku{
    var mat: [[Int]] = []
    var numberOfRowsColumns: Int// Number of rows and columns
    var numberOfMissingDigits: Int //Number of digits missing
    var sqrt: Int = 0
    
    init(numberOfRowsColumns: Int, numberOfMissingDigits: Int){
        self.numberOfMissingDigits = numberOfMissingDigits
        self.numberOfRowsColumns = numberOfRowsColumns
    }
    func fillValues(){
        fillDiagonal();
        fillRemaining(row: 0,column: sqrt)
        removeKDigits()
    }
    
    func fillDiagonal(){
        var index:Int = 0
        while index < numberOfRowsColumns{
            fillBox(row: index, column: index)
            index = index + sqrt
        }
    }
    
    func fillRemaining(row: Int, column: Int){
        
    }
    
    func removeKDigits(){
        var count: Int = numberOfMissingDigits
        while (count != 0){
            let cellId = randomGenerator(num: (numberOfRowsColumns * numberOfRowsColumns)) - 1
        }
    }
    
    func unUsedInRow(row: Int, number: Int) -> Bool{
        for columnIndex in (0 ..< numberOfRowsColumns){
            if(mat[row][columnIndex] == number){
                return false
            }
        }
        return true
    }
    
    func unUsedInColumn(column: Int, number: Int) -> Bool{
        for rowIndex in (0 ..< numberOfRowsColumns){
            if(mat[rowIndex][column] == number){
                return false
            }
        }
        return true
    }
    
    func checkIfSafe(row: Int, column: Int, num: Int) -> Bool{
        return (unUsedInRow(row: row, number: num) && unUsedInColumn(column: column, number: num) && unUsedInBox(row: row - row%sqrt, column: column - column%sqrt, num: num))
    }
    
    func fillBox(row: Int, column: Int){
        var num: Int
        for rowIndex in (0 ..< sqrt) {
            for columnIndex in (0 ..< sqrt){
                repeat{
                    num = randomGenerator(num: numberOfRowsColumns)
                    
                }while !unUsedInBox(row: row, column: column, num: num)
                mat[row + rowIndex][column + columnIndex] = num
            }
        }
    }
    
    func unUsedInBox(row: Int, column: Int, num: Int) -> Bool{
        for rowIndex in (0 ..< sqrt) {
            for columnIndex in (0 ..< sqrt){
                if (mat[row + rowIndex][column + columnIndex] == num){
                    return false
                }
            }
        }
        return true
    }
    
    func randomGenerator(num: Int) -> Int{
        let random = Double(arc4random()) * Double(num + 1)
        return Int(random)
    }
}
