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
    @IBOutlet var sudokuBoard: UICollectionView!
    var newGame:Bool = false
    var changeColorSelectionOrder:Bool = false
    var pencilSelected:Bool = false
    var currentColorBeingUsedIndex: Int = 0
    let realm = try! Realm()
    var canidates:Bool = false
    var indexCount:Int = -1
    let colorsForEachSection:[CGColor] = [ UIColor.red.cgColor,UIColor.black.cgColor,UIColor.blue.cgColor]
    var sudoku: Sudoku!;
    var screenSize : CGRect!
    var screenWidth : CGFloat!
    var screenHeight : CGFloat!
    var sudokuRowSelected: Int = -1
    var sudokuColumnSelected: Int = -1
    let alphaHalf: CGFloat = 0.5
    let alphaFull: CGFloat = 1.0
    var sudokuGame: Results<SudokuRow>?
    var highlightedLocations:[Highlight] = []
    var selectedCategory : SudokuRow? {
        didSet{
            loadItems()
        }
    }
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        indexCount = -1
        changeColorSelectionOrder = false
        switch sender.tag{
        case 1,2,3,4,5,6,7,8,9 :
            if (sudokuRowSelected != -1 && sudokuColumnSelected != -1){
                if (!sudoku.addNumberToBoard(pencilSelected: pencilSelected, numberSelected: sender.tag, row: sudokuRowSelected, column: sudokuColumnSelected, realm:realm)) {
                    DispatchQueue.main.async {
                        if let cell = self.sudokuBoard!.cellForItem(at: self.sudoku.findConflict(numberSelected: sender.tag, row: self.sudokuRowSelected, column: self.sudokuColumnSelected)) as? SudokuBoardElementViewCell {
                            UIView.animate(withDuration: 2, delay: 0.0, options: .curveEaseInOut, animations: {
                                cell.sudokuLabel.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                            }, completion: { (done) in
                                cell.sudokuLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)})
                        }
                    }
                }
                if(!pencilSelected){
                    if (canidates){
                        sudoku.generateCandidates(realm: realm)
                    }
                    sudoku.checkSelectedState(row: sudokuRowSelected, column: sudokuColumnSelected, realm: realm)
                }
                self.sudokuBoard.reloadData()
            }
        case 10 :
            print("10 clicked")
        case 11 :
            print("11 clicked")
        case 12 :
            pencilSelected = !pencilSelected
            pencilButton.isSelected = pencilSelected
        case 13 :
            print("13 clicked")
        case 14:
            canidates = true
            sudoku.generateCandidates(realm: realm)
            self.sudokuBoard.reloadData()
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
        screenSize = self.view.frame
        screenWidth = screenSize.width/9
        screenHeight = screenSize.height/9
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
        canidates = true
        if let sudokuGame = realm.objects(SudokuRow.self) as Results<SudokuRow>? {
            sudoku = Sudoku(previousBoard: sudokuGame, realm: realm)
            outerLoop: for i in 0..<sudoku.getMatBoard().count{
                for j in 0..<sudoku.getMatBoard()[i].count{
                    print("\(sudoku.getMatBoard()[i][j])")
                    if (sudoku.getMatBoard()[i][j].possibleValues.isEmpty && sudoku.getMatBoard()[i][j].isHidden && !sudoku.getMatBoard()[i][j].isSolved){
                        canidates = false
                        print("break")
                        break outerLoop
                    }
                }
            }
        
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
            var possibleValuesLabel: String = ""
            if (elment.isHidden && !elment.isSolved){
                for i in elment.possibleValues {
                    possibleValuesLabel.append("\(i) ")
                }
                cell.setLabel(sudokuLabel: possibleValuesLabel)
            }else {
                cell.setLabel(sudokuLabel: "\(String(elment.boxValue))")
            }
            cell.setLabelColor(color: (elment.isHidden || elment.isSolved) ? .blue : .black)
            if (!possibleValuesLabel.isEmpty){
                cell.setLabelColor(color:.gray)
            }
            var highlightedValueFound:Bool = false
            for highlightedValue in highlightedLocations{
                if (highlightedValue.row == indexPath.row && highlightedValue.column == indexPath.section){
                    highlightedValueFound = true
                    break
                }
            }
            if (!highlightedValueFound){
                cell.setViewLabel(color: elment.isSelected ?  .yellow :.white)
            } else {
                cell.setViewLabel(color: .cyan)
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
        indexCount = -1
        changeColorSelectionOrder = false
        // find all rows and columns that contains that number either from a possible value or the boxValue
        if (sudoku.checkSelectedState(row: sudokuRowSelected, column: sudokuColumnSelected, realm: realm) && sudoku.canHighlight(selectedRow: sudokuRowSelected, selectedColumn:sudokuColumnSelected)) {
            highlightedLocations = sudoku.highlightAllBoxesWithSameNumber(numberInBox: sudoku.getMatBoard()[sudokuRowSelected][sudokuColumnSelected].boxValue)
        } else {
            highlightedLocations = []
        }
        self.sudokuBoard.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: screenWidth);
        
    }
}
