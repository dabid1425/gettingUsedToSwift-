//
//  Sudoku.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 5/23/22.
//

import Foundation
class Sudoku{
    var mat: [[Int]] = [[]]
    var numberOfRowsColumns: Int// Number of rows and columns
    var numberOfMissingDigits: Int //Number of digits missing
    var squareRootValue: Int = 0
    
    init(numberOfRowsColumns: Int, numberOfMissingDigits: Int){
        self.numberOfMissingDigits = numberOfMissingDigits
        self.numberOfRowsColumns = numberOfRowsColumns
        self.squareRootValue = Int(sqrt(Double(numberOfRowsColumns)))
        mat = Array(repeating: Array(repeating: 0, count: numberOfRowsColumns), count: numberOfRowsColumns)
    }
    func fillValues(){
        fillDiagonal();
        var zeroIndex = 0
        var dummyVal = squareRootValue
        fillRemaining(row: &zeroIndex,column: &dummyVal)
        removeKDigits()
    }
    
    func fillDiagonal(){
        var index:Int = 0
        while index < numberOfRowsColumns{
            fillBox(row: index, column: index)
            index = index + squareRootValue
        }
    }
    
    func unUsedInBox(row: Int, column: Int, num: Int) -> Bool{
        var rowIndex:Int = 0
        while (rowIndex < squareRootValue - 1) {
            var columnIndex:Int = 0
            while (columnIndex < squareRootValue - 1) {
                if (mat[row + rowIndex][column + columnIndex] == num){
                    return false
                }
                columnIndex+=1
            }
            rowIndex+=1
        }
        return true
    }
    
    func fillBox(row: Int, column: Int){
        var num: Int
        var rowIndex:Int = 0
        while (rowIndex < squareRootValue - 1) {
            var columnIndex:Int = 0
            while (columnIndex < squareRootValue - 1) {
                repeat{
                    num = randomGenerator(numberOfRowsColumns)
                    
                }while !unUsedInBox(row: row, column: column, num: num)
                mat[row + rowIndex][column + columnIndex] = num
                columnIndex+=1
            }
            rowIndex+=1
        }
    }
    
    func randomGenerator(_ n:Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    } // end
    func checkIfSafe(row: Int, column: Int, num: Int) -> Bool{
        return (unUsedInRow(row: row, number: num) && unUsedInColumn(column: column, number: num) && unUsedInBox(row: row - row%squareRootValue, column: column - column%squareRootValue, num: num))
    }
    
    func unUsedInRow(row: Int, number: Int) -> Bool{
        var columnIndex:Int = 0
        while (columnIndex < numberOfRowsColumns){
            if(mat[row][columnIndex] == number){
                return false
            }
            columnIndex+=1
        }
        return true
    }
    
    func unUsedInColumn(column: Int, number: Int) -> Bool{
        var rowIndex:Int = 0
        while (rowIndex < numberOfRowsColumns){
            if(mat[rowIndex][column] == number){
                return false
            }
            rowIndex+=1
        }
        return true
    }
   
    
    
    
    
    func fillRemaining(row: inout Int, column: inout Int) -> Bool{
        if (column >= numberOfRowsColumns && row < numberOfRowsColumns - 1){
            row+=1
            column = 0
        }
            if (row >= numberOfRowsColumns && column >= numberOfRowsColumns){
                return true
            }
            if (row < squareRootValue){
                if (column < squareRootValue){
                    column = squareRootValue
                }
            } else if (row < numberOfRowsColumns - squareRootValue){
                if (column == Int(row/squareRootValue) * squareRootValue){
                    column = column + squareRootValue
                }
            } else {
                if (column == numberOfRowsColumns - squareRootValue){
                    row+=1
                    column = 0
                    if (row >= numberOfRowsColumns){
                        return true
                    }
                }
            }
            var num: Int = 1
            while (num <= numberOfRowsColumns){
                if (checkIfSafe(row: row, column: column, num: num)){
                    mat[row][column] = num
                    column+=1
                    if (fillRemaining(row: &row, column: &column)){
                        return true
                    }
                    mat[row][column] = 0;
                }
                num+=1
            }
        return false;
    }
    
    
    func removeKDigits(){
        var count: Int = numberOfMissingDigits
        while (count != 0){
            let cellId = randomGenerator((numberOfRowsColumns * numberOfRowsColumns))
            let i = Int(cellId / numberOfRowsColumns)
            var j = cellId % 9
            if (j != 0){
                j = j - 1
                if (mat[i][j] != 0 ){
                    count-=1
                    mat[i][j] = 0
                }
            }
        }
    }
    
    func printBoard(){
        var i:Int = 0
        while (i < numberOfRowsColumns) {
            var j:Int = 0
            var row:String = ""
            while (j < numberOfRowsColumns) {
                row.append("\(mat[i][j]) ")
                j+=1
            }
            i+=1
            print(row)
        }
    }
}
