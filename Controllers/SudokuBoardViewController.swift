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
    var changeColorSelectionOrder:Bool = false
    var pencilSelected:Bool = false
    var currentColorBeingUsedIndex: Int = 0
    let realm = try! Realm()
    var indexCount:Int = -1
    let colorsForEachSection:[CGColor] = [ UIColor.red.cgColor,UIColor.black.cgColor,UIColor.blue.cgColor]
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
        minimumInteritemSpacing: 2,
        minimumLineSpacing: 2
    )
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        switch sender.tag{
        case 1,2,3,4,5,6,7,8,9 :
            sudoku.addNumberToBoard(pencilSelected: pencilSelected, numberSelected: sender.tag, row: sudokuRowSelected, column: sudokuColumnSelected, realm:realm)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (newGame) {
            newGameFunc()
            //sudoku.printBoard();
        } else {
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        sudokuBoard.delegate = self
        sudokuBoard.dataSource = self
        sudokuBoard.collectionViewLayout = columnLayout
        sudokuBoard.contentInsetAdjustmentBehavior = .always
        sudokuBoard.register(UINib(nibName:"SudokuBoardElementViewCell", bundle: nil), forCellWithReuseIdentifier: "SudokuCell")
        
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
        self.sudokuBoard.reloadData()
    }
    func newGameFunc(){
        let alert = UIAlertController(title: "Select game difficulty ", message: "", preferredStyle: .actionSheet)
        let easy = UIAlertAction(title: "Easy", style: .default) { [self] (action) in
            createNewGame(K: 20)
        }
        let medium = UIAlertAction(title: "Medium", style: .default) { [self] (action) in
            createNewGame(K: 30)
        }
        let hard = UIAlertAction(title: "Hard", style: .default) { [self] (action) in
            createNewGame(K: 40)
        }
        let extremlyHard = UIAlertAction(title: "Extremly Hard", style: .default) { [self] (action) in
            createNewGame(K: 50)
        }
        let extreme = UIAlertAction(title: "Extreme", style: .default) { [self] (action) in
            createNewGame(K: 60)
        }
        alert.addAction(easy)
        alert.addAction(medium)
        alert.addAction(hard)
        alert.addAction(extremlyHard)
        alert.addAction(extreme)
        present(alert, animated: true, completion: nil)
        
    }
    func loadItems(){
        
        if let sudokuGame = realm.objects(SudokuRow.self) as Results<SudokuRow>? {
            sudoku = Sudoku(previousBoard: sudokuGame)
            
            if (sudoku.isEmpty){
                let alert = UIAlertController(title: "No game saved ", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Make new game", style: .default) { [self] (action) in
                    self.newGameFunc()
                }
                let cancel = UIAlertAction(title: "Go back", style: .default) { [self] (action) in
                    navigationController?.popViewController(animated: true)
                }
                alert.addAction(action)
                alert.addAction(cancel)
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
        if (sudoku == nil) {
            return 0
        }
        return sudoku.getMatBoard().count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return rows
        if (sudoku == nil) {
            return 0
        }
        return sudoku.getMatBoard()[section].count
        
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
    UICollectionViewCell {
        if let cell = sudokuBoard.dequeueReusableCell(withReuseIdentifier: "SudokuCell", for: indexPath) as? SudokuBoardElementViewCell{
            cell.layer.borderColor = getColor(indexPath: indexPath)
            cell.layer.borderWidth = 1
            
            //setCharacter
            let elment = sudoku.getMatBoard()[indexPath.row][indexPath.section]
            if (elment.isHidden && !elment.isSolved){
                var possibleValuesLabel: String = ""
                for i in elment.possibleValues {
                    possibleValuesLabel.append("\(i) ")
                }
                cell.changeLabelView(possibleValues: true)
                cell.setLabel(label: possibleValuesLabel)
            }else {
                cell.changeLabelView(possibleValues: false)
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: sudokuBoard.frame.size.height/10, height: sudokuBoard.frame.size.height/10)
    }
}
