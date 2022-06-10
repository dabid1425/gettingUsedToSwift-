//
//  SudokuBoardViewController.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 5/26/22.
//

import UIKit
import RealmSwift
class SudokuBoardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var pencilButton: UIButton!
    @IBOutlet weak var sudokuBoard: UICollectionView!
    var newGame:Bool = false
    var pencilSelected:Bool = false
    let realm = try! Realm()
    let K:Int = 20
    var sudoku: Sudoku!;
    var sudokuRowSelected: Int = 0
    var sudokuColumnSelected: Int = 0
    let alphaHalf: CGFloat = 0.5
    let alphaFull: CGFloat = 1.0
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
    
    func addNumberToBoard (valueSelected: Int){
        if pencilSelected {
            
        } else {
            
        }
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        switch sender.tag{
        case 1,2,3,4,5,6,7,8,9 :
            addNumberToBoard(valueSelected: sender.tag)
        case 10 :
            print("10 clicked")
        case 11 :
            print("11 clicked")
        case 12 :
            pencilSelected = !pencilSelected
            pencilButton.isSelected = pencilSelected
        case 13 :
            print("13 clicked")
        default:
            print("unable to determine click")
        }
        
    }
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
                let values = sudoku.getMatBoard()[indexPath.section][indexPath.item].possibleValues
                let newString = values.replacingOccurrences(of: ",", with: " ", options: .literal, range: nil)
                cell.setLabel(label: newString)
                cell.setAlphaValue(alphaValue: alphaHalf)
            } else {
                cell.setAlphaValue(alphaValue: alphaFull)
                cell.setLabel(label: String(sudoku.getMatBoard()[indexPath.section][indexPath.item].boxValue))
            }
            if cell.isSelected {
                
            }
            
            return cell
        }
        let cell = sudokuBoard.dequeueReusableCell(withReuseIdentifier: "SudokuCell", for: indexPath)
        cell.backgroundColor = UIColor.green
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        sudokuRowSelected = indexPath.row
        sudokuColumnSelected = indexPath.section
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
}
