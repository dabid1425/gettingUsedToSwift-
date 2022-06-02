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
        fillRemaining(i: 0,j: squareRootValue)
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
        return Int(Int(floor(Double.random(in: 0..<1))) * n + 1)
    } // end
    func checkIfSafe(i: Int, j: Int, num: Int) -> Bool{
        return (unUsedInRow(i: i, number: num) && unUsedInColumn(j: j, number: num) && unUsedInBox(row: i - i%squareRootValue, column: j - j%squareRootValue, num: num))
    }
    
    func unUsedInRow(i: Int, number: Int) -> Bool{
        var columnIndex:Int = 0
        while (columnIndex < numberOfRowsColumns){
            if(mat[i][columnIndex] == number){
                return false
            }
            columnIndex+=1
        }
        return true
    }
    
    func unUsedInColumn(j: Int, number: Int) -> Bool{
        var rowIndex:Int = 0
        while (rowIndex < numberOfRowsColumns){
            if(mat[rowIndex][j] == number){
                return false
            }
            rowIndex+=1
        }
        return true
    }
    
    
    
    
    
    func fillRemaining(i: Int, j: Int) -> Bool{
        var rowVal = i
        var columnVal = j
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
            if (columnVal == Int(rowVal/squareRootValue) * squareRootValue){
                columnVal = columnVal + squareRootValue
            }
        } else {
            if (columnVal == numberOfRowsColumns - squareRootValue){
                rowVal+=1
                columnVal = 0
                if (rowVal >= numberOfRowsColumns){
                    return true
                }
            }
        }
        var num: Int = 1
        while (num <= numberOfRowsColumns){
            if (checkIfSafe(i: rowVal, j: columnVal, num: num)){
                mat[rowVal][columnVal] = num
                if (fillRemaining(i: rowVal, j: columnVal + 1)){
                    return true
                }
                mat[rowVal][columnVal] = 0;
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
