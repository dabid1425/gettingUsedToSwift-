//
//  Sudoku.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 5/23/22.
//

import Foundation
import RealmSwift
class Sudoku{
    var mat:[[SudokuBox]] = []
    let numberOfRowsColumns: Int = 9// Number of rows and columns
    var numberOfMissingDigits: Int = 0 //Number of digits missing
    var squareRootValue: Int = 3
    var isEmpty = true
    
    init(previousBoard: Results<SudokuRow> , realm: Realm){
        var rowIndex: Int = 0
        for i in previousBoard{
            var aRow : [SudokuBox] = []
            var columnIndex: Int = 0
            for j in i.currentRow {
                isEmpty = !i.initialized
                do{
                    try realm.write{
                        j.isSelected = false
                    }
                }catch{
                    
                }
                
                aRow.append(j)
                columnIndex+=1
            }
            rowIndex+=1
            mat.append(aRow)
        }
    }
    init(numberOfMissingDigits: Int){
        self.numberOfMissingDigits = numberOfMissingDigits
        self.squareRootValue = Int(sqrt(Double(numberOfRowsColumns)))
        for _ in 0..<numberOfRowsColumns {
            var aRow : [SudokuBox] = []
            for _ in 0..<numberOfRowsColumns {
                let newImage = SudokuBox()
                aRow.append(newImage)
            }
            mat.append(aRow)
        }
    }
    func fillValues(){
        fillDiagonal();
        fillRemaining(i: 0,j: squareRootValue)
        removeKDigits()
    }
    
    func checkSelectedState(row: Int, column: Int,realm: Realm) -> Bool{
        var selectedState:Bool = false
        do {
            try realm.write{
                for i in 0..<numberOfRowsColumns{
                    for j in 0..<numberOfRowsColumns{
                        if (i == row && j == column){
                            mat[i][j].isSelected = !mat[i][j].isSelected
                            selectedState = mat[i][j].isSelected
                        } else {
                            mat[i][j].isSelected = false
                        }
                    }
                }
            }
        } catch {
        }
        return selectedState
    }
    
    func addNumberToBoard(pencilSelected: Bool, numberSelected: Int, row: Int, column: Int,realm: Realm) -> Bool{
        if (pencilSelected) {
            if (mat[row][column].possibleValues.contains(String(numberSelected))){
                do {
                    try realm.write{
                        //realm.delete(item)
                        mat[row][column].possibleValues = mat[row][column].possibleValues.replacingOccurrences(of: String(numberSelected), with: "", options: NSString.CompareOptions.literal, range: nil)
                    }
                } catch {
                }
                return true
            } else if (checkIfSafe(i: row, j: column, num: numberSelected)) {
                do {
                    try realm.write{
                        //realm.delete(item)
                        self.mat[row][column].possibleValues.append("\(String(numberSelected)) ")
                        var seperatedValues = self.mat[row][column].possibleValues.split(separator: " ")
                        seperatedValues.sort()
                        self.mat[row][column].possibleValues = ""
                        for i in seperatedValues{
                            self.mat[row][column].possibleValues.append("\(String(i)) ")
                        }
                        self.mat[row][column].isHidden = true
                    }
                    
                } catch {
                }
                
                return true
            }
        } else {
            if (mat[row][column].isHidden){
                if (checkIfRightValue(i: row, j: column, num: numberSelected)){
                    do {
                        try realm.write{
                            //realm.delete(item)
                            mat[row][column].isSolved = true
                        }
                    } catch {
                    }
                    return true
                }
            }
        }
        return false
    }
    
    func generateCandidates(realm: Realm){
        for i in 0..<mat.count{
            for j in 0..<mat[i].count{
                if (mat[i][j].isHidden && !mat[i][j].isSolved){
                    var needToReplace:Bool = false
                    var replacementString:String = ""
                    for k in 1..<10{
                        if (canBeCanidate(i: i, j: j, num: k)){
                            replacementString.append("\(String(k)) ")
                            needToReplace = true
                        }
                    }
                    if (needToReplace){
                        do{
                            try realm.write{
                                mat[i][j].possibleValues = replacementString
                            }
                        }catch{
                            
                        }
                    }
                }
            }
        }
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
        while (rowIndex < squareRootValue) {
            var columnIndex:Int = 0
            while (columnIndex < squareRootValue) {
                if (mat[row + rowIndex][column + columnIndex].boxValue == num) {
                    return false
                }
                columnIndex+=1
            }
            rowIndex+=1
        }
        return true
    }
    
    func getMatBoard() -> [[SudokuBox]]{
        return mat
    }
    
    func fillBox(row: Int, column: Int){
        var num: Int
        var rowIndex:Int = 0
        while (rowIndex < squareRootValue) {
            var columnIndex:Int = 0
            while (columnIndex < squareRootValue) {
                repeat{
                    num = randomGenerator(numberOfRowsColumns)
                    
                } while !unUsedInBox(row: row, column: column, num: num)
                mat[row + rowIndex][columnIndex + column].boxValue = num
                columnIndex+=1
            }
            rowIndex+=1
        }
    }
    
    func randomGenerator(_ n:Int) -> Int {
        return Int(Int(floor(Double.random(in: 0..<1) * Double(n) + 1)))
    } // end
    func checkIfSafe(i: Int, j: Int, num: Int) -> Bool{
        return (unUsedInRow(i: i, number: num) && unUsedInColumn(j: j, number: num) && unUsedInBox(row: i - i%squareRootValue, column: j - j%squareRootValue, num: num))
    }
    
    func checkIfRightValue(i: Int, j: Int, num: Int) -> Bool{
        return mat[i][j].boxValue == num
    }
    func canBeCanidate(i: Int, j: Int, num: Int) -> Bool{
        return (canBeCanidateInRow(i: i, number: num) && canBeCanidateInColumn(j: j, number: num) && canBeCanidateInBox(row: i - i%squareRootValue, column: j - j%squareRootValue, num: num))
    }
    
    func canBeCanidateInRow(i: Int, number: Int) -> Bool{
        var columnIndex:Int = 0
        while (columnIndex < numberOfRowsColumns){
            print(mat[i][columnIndex])
            if(mat[i][columnIndex].boxValue == number && (!mat[i][columnIndex].isHidden || mat[i][columnIndex].isSolved)){
                return false
            }
            columnIndex+=1
        }
        return true
    }
    
    func canHighlight(selectedRow:Int , selectedColumn:Int) -> Bool{
        return !mat[selectedRow][selectedColumn].isHidden || mat[selectedRow][selectedColumn].isSolved
    }
    
    func highlightAllBoxesWithSameNumber(numberInBox:Int) ->[Highlight]{
        var highlightedValues:[Highlight] = []
        for i in 0..<numberOfRowsColumns{
            for j in 0..<numberOfRowsColumns{
                var highlightedObj: Highlight = Highlight()
                if (((!mat[i][j].isHidden || mat[i][j].isSolved) && mat[i][j].boxValue == numberInBox) || mat[i][j].possibleValues.contains(String(numberInBox))) {
                    highlightedObj = Highlight(row: i, column: j)
                    highlightedValues.append(highlightedObj)
                }
            }
        }
        return highlightedValues
    }
    
    func canBeCanidateInColumn(j: Int, number: Int) -> Bool{
        var rowIndex:Int = 0
        while (rowIndex < numberOfRowsColumns){
            print(mat[rowIndex][j])
            if(mat[rowIndex][j].boxValue == number && (!mat[rowIndex][j].isHidden || mat[rowIndex][j].isSolved)){
                return false
            }
            rowIndex+=1
        }
        return true
    }
    
    func canBeCanidateInBox(row: Int, column: Int, num: Int) -> Bool{
        var rowIndex:Int = 0
        while (rowIndex < squareRootValue) {
            var columnIndex:Int = 0
            while (columnIndex < squareRootValue) {
                if (mat[row + rowIndex][column + columnIndex].boxValue == num
                    && (!mat[row + rowIndex][column + columnIndex].isHidden || mat[row + rowIndex][column + columnIndex].isSolved)) {
                    return false
                }
                columnIndex+=1
            }
            rowIndex+=1
        }
        return true
    }
    
    func unUsedInRow(i: Int, number: Int) -> Bool{
        var columnIndex:Int = 0
        while (columnIndex < numberOfRowsColumns){
            if(mat[i][columnIndex].boxValue == number){
                return false
            }
            columnIndex+=1
        }
        return true
    }
    
    func unUsedInColumn(j: Int, number: Int) -> Bool{
        var rowIndex:Int = 0
        while (rowIndex < numberOfRowsColumns){
            if(mat[rowIndex][j].boxValue == number){
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
                mat[rowVal][columnVal].boxValue = num
                if (fillRemaining(i: rowVal, j: columnVal + 1)){
                    return true
                }
                mat[rowVal][columnVal].boxValue = 0;
            }
            num+=1
        }
        return false;
    }
    
    
    func removeKDigits(){
        var count: Int = numberOfMissingDigits
        while (count != 0){
            let cellId = randomGenerator((numberOfRowsColumns * numberOfRowsColumns)) - 1
            let i = Int(cellId / numberOfRowsColumns)
            var j = cellId % 9
            if (j != 0){
                j = j - 1
                if (!mat[i][j].isHidden){
                    count-=1
                    mat[i][j].isHidden = true
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
                row.append("\(mat[i][j].boxValue) ")
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
