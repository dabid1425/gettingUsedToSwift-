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
    var sudokuRowSelected: Int = -1
    var sudokuColumnSelected: Int = -1
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
    
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        switch sender.tag{
        case 1,2,3,4,5,6,7,8,9 :
            if(sudoku.addNumberToBoard(pencilSelected: pencilSelected, numberSelected: sender.tag, row: sudokuRowSelected, column: sudokuColumnSelected)){
                
            }
            self.saveData()
            self.sudokuBoard.reloadData()
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
            newGameFunc()
            //sudoku.printBoard();
        } else {
            loadItems()
        }
    }
    func newGameFunc(){
        sudoku = Sudoku(numberOfMissingDigits: K)
        sudoku.fillValues();
        saveData()
        self.sudokuBoard.reloadData()
    }
    func loadItems(){
        
        if let sudokuGame = realm.objects(SudokuRow.self) as Results<SudokuRow>? {
            sudoku = Sudoku(previousBoard: sudokuGame)
            
            if (sudoku.isEmpty){
                let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Add", style: .default) { [self] (action) in
                    self.newGameFunc()
                }
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                self.sudokuBoard.reloadData()
            }
        }
    }
    
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
            let elment = sudoku.getMatBoard()[indexPath.section][indexPath.item]
            if (elment.isHidden && !elment.isSolved){
                var possibleValuesLabel: String = ""
                for i in elment.possibleValues {
                    possibleValuesLabel.append("\(i) ")
                }
                cell.setLabel(label: possibleValuesLabel)
                cell.setAlphaValue(alphaValue: alphaHalf)
            }else {
                cell.setAlphaValue(alphaValue: alphaFull)
                cell.setLabel(label: String(elment.boxValue))
                cell.setLabelColor(color: (elment.isHidden || elment.isSolved) ? .blue : .black )
            }
            if  indexPath.row == sudokuRowSelected && indexPath.section == sudokuColumnSelected {
                if (cell.getSelected()){
                    sudokuRowSelected = -1
                    sudokuColumnSelected = -1
                    cell.setSelectValue()
                    cell.setViewLabel(color: .white)
                   
                } else {
                    cell.setViewLabel(color: .yellow)
                    cell.setSelectValue()
                }
               
            } else {
                cell.setViewLabel(color: .white)
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
        self.sudokuBoard.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
}
