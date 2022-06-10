//
//  SudokuBoardViewController.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 5/26/22.
//

import UIKit
import RealmSwift
class SudokuBoardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var sudokuBoard: UICollectionView!
    var newGame:Bool = false
    let realm = try! Realm()
    let K:Int = 20
    var sudoku: Sudoku!;
    
    var sudokuGame: Results<SudokuRow>?
    var selectedCategory : SudokuRow? {
        didSet{
            loadItems()
        }
    }
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let columnLayout = ColumnFlowLayout(
        cellsPerRow: 9,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sudokuBoard.delegate = self
        sudokuBoard.dataSource = self
        sudokuBoard.collectionViewLayout = columnLayout
        sudokuBoard.contentInsetAdjustmentBehavior = .always
        sudokuBoard.register(UINib(nibName:"SudokuBoardElementViewCell", bundle: nil), forCellWithReuseIdentifier: "SudokuCell")
        if (newGame) {
            sudoku = Sudoku(numberOfMissingDigits: K)
            sudoku.fillValues();
            for i in 0..<sudoku.getMatBoard().count{
                let sudokuElement = SudokuRow()
                sudokuElement.rowNumber = i
                for j in 0..<sudoku.getMatBoard()[i].count{
                    sudokuElement.currentRow.append(sudoku.getMatBoard()[i][j])
                }
                self.saveData(sudokuGame: sudokuElement)
            }
            //sudoku.printBoard();
        } else {
            loadItems()
        }
    }
    
    func loadItems(){
        
        if let sudokuGame = realm.objects(SudokuRow.self) as Results<SudokuRow>? {
            sudoku = Sudoku(previousBoard: sudokuGame)
        }
    }
    
    func saveData(sudokuGame: SudokuRow){
        //Using Realm
        do{
            try realm.write(){
                print("\(sudokuGame)")
                realm.add(sudokuGame)
            }
            
        }catch{
            print("You did done fucked it")
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //return columns
        return sudoku.getMatBoard().count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return rows
        return sudoku.getMatBoard()[section].count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
    UICollectionViewCell {
        if let cell = sudokuBoard.dequeueReusableCell(withReuseIdentifier: "SudokuCell", for: indexPath) as? SudokuBoardElementViewCell{
            cell.layer.borderColor = UIColor.blue.cgColor
            cell.layer.borderWidth = 1
            //setCharacter
            if (sudoku.getMatBoard()[indexPath.section][indexPath.item].hidden){
                cell.setLabel(label: "0")
            } else {
                cell.setLabel(label: String(sudoku.getMatBoard()[indexPath.section][indexPath.item].boxValue))
            }
            
            return cell
        }
        let cell = sudokuBoard.dequeueReusableCell(withReuseIdentifier: "SudokuCell", for: indexPath)
        cell.backgroundColor = UIColor.green
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
}
