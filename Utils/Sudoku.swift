//
//  Sudoku.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 5/23/22.
//

import Foundation
class Sudoku{
    var mat: [[Int]] = [[]]
    var correctAnswer: [[Int]] = [[]]
    let numberOfRowsColumns: Int = 9// Number of rows and columns
    var numberOfMissingDigits: Int //Number of digits missing
    var squareRootValue: Int = 0
    
    init(numberOfMissingDigits: Int){
        self.numberOfMissingDigits = numberOfMissingDigits
        self.squareRootValue = Int(sqrt(Double(numberOfRowsColumns)))
        mat = Array(repeating: Array(repeating: 0, count: numberOfRowsColumns), count: numberOfRowsColumns)
    }
    func fillValues(){
        fillDiagonal();
        fillRemaining(row: 0,column: squareRootValue)
        //removeKDigits()
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
        while (rowIndex < squareRootValue) {
            var columnIndex:Int = 0
            while (columnIndex < squareRootValue) {
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
        return Int.random(in: 1..<n)
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
    
    
    
    
    
    func fillRemaining(row: Int, column: Int) -> Bool{
        var rowVal = row
        var columnVal = column
        if (columnVal >= numberOfRowsColumns && rowVal < numberOfRowsColumns - 1){
            rowVal+=1
            columnVal = 0
        }
        if (rowVal >= numberOfRowsColumns && columnVal >= numberOfRowsColumns){
            return true
        }
        if (rowVal < squareRootValue){
            if (columnVal < squareRootValue){
                columnVal = squareRootValue
            }
        } else if (rowVal < numberOfRowsColumns - squareRootValue){
            if (columnVal == Int(row/squareRootValue) * squareRootValue){
                columnVal = columnVal + squareRootValue
            }
        } else {
            if (columnVal == numberOfRowsColumns - squareRootValue){
                rowVal+=1
                columnVal = 0
                if (row >= numberOfRowsColumns){
                    return true
                }
            }
        }
        var num: Int = 1
        while (num <= numberOfRowsColumns){
            if (checkIfSafe(row: rowVal, column: columnVal, num: num)){
                mat[rowVal][columnVal] = num
                columnVal+=1
                if (fillRemaining(row: rowVal, column: columnVal)){
                    return true
                }
                //mat[row][column] = 0;
            }
            num+=1
        }
        return false;
    }
    
    
    func removeKDigits(){
        var count: Int = numberOfMissingDigits
        correctAnswer = mat
        while (count != 0){
            let cellId = randomGenerator((numberOfRowsColumns * numberOfRowsColumns)) - 1
            let i = Int(cellId / numberOfRowsColumns)
            var j = cellId % 9
            if (j != 0){
                j = j - 1
                if (mat[i][j] != 0 ){
                    count-=1
                    //  mat[i][j] = 0
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
        print("")
        print("")
        print("")
        
    }
}
