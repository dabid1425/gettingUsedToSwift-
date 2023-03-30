//
//  SudokuBoardViewController.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 5/26/22.
//

import UIKit
class SudokuBoardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var pencilButton: UIButton!
    @IBOutlet var sudokuBoard: UICollectionView!
    var viewModel: SudokuGameViewModel!
    var selectedCategory : SudokuRow? {
        didSet{
            loadItems()
        }
    }
    @IBAction func buttonClicked(_ sender: UIButton) {
        viewModel.sudokuGameModel.indexCount = -1
        viewModel.sudokuGameModel.changeColorSelectionOrder = false
        switch sender.tag{
        case 1,2,3,4,5,6,7,8,9 :
            if (self.viewModel.sudokuGameModel.sudokuRowSelected != -1 && self.viewModel.sudokuGameModel.sudokuColumnSelected != -1){
                if (!viewModel.sudokuGameModel.sudoku.addNumberToBoard(pencilSelected: viewModel.sudokuGameModel.pencilSelected, numberSelected: sender.tag, row: self.viewModel.sudokuGameModel.sudokuRowSelected, column: self.viewModel.sudokuGameModel.sudokuColumnSelected, realm:viewModel.sudokuGameModel.realm)) {
                    let dummyIndex = IndexPath(row: viewModel.sudokuGameModel.sudokuRowSelected, section: viewModel.sudokuGameModel.sudokuColumnSelected)
                    DispatchQueue.main.async {
                        let indexPath = self.viewModel.sudokuGameModel.sudoku.findConflict(numberSelected: sender.tag, row: self.viewModel.sudokuGameModel.sudokuRowSelected, column: self.viewModel.sudokuGameModel.sudokuColumnSelected)
                        if ( indexPath.row != -1 && indexPath.row != -1){
                            if let cell = self.sudokuBoard!.cellForItem(at: indexPath) as? SudokuBoardElementViewCell {
                                UIView.animate(withDuration: 2, delay: 0.0, options: .curveEaseInOut, animations: {
                                    cell.sudokuLabel.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                                }, completion: { (done) in
                                    cell.sudokuLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)})
                            }
                        } else {
                            if let cell = self.sudokuBoard!.cellForItem(at: dummyIndex) as? SudokuBoardElementViewCell {
                                UIView.animate(withDuration: 2, delay: 0.0, options: .curveEaseInOut, animations: {
                                    cell.collectionView.backgroundColor = .red
                                }, completion: { (done) in
                                    cell.collectionView.backgroundColor = .yellow})
                            }
                        }
                        
                    }
                    
                } else {
                    if(!viewModel.sudokuGameModel.pencilSelected){
                        if (viewModel.sudokuGameModel.canidates){
                            viewModel.sudokuGameModel.sudoku.generateCandidates(realm: viewModel.sudokuGameModel.realm)
                        }
                        viewModel.sudokuGameModel.sudoku.checkSelectedState(row: viewModel.sudokuGameModel.sudokuRowSelected, column: viewModel.sudokuGameModel.sudokuColumnSelected, realm: viewModel.sudokuGameModel.realm)
                        self.viewModel.sudokuGameModel.sudokuColumnSelected = -1
                        self.viewModel.sudokuGameModel.sudokuRowSelected = -1
                        if (viewModel.sudokuGameModel.sudoku.checkIfSolved()){
                            newGameDialog()
                        }
                    }
                }
                self.sudokuBoard.reloadData()
            }
        case 10 :
            viewModel.sudokuGameModel.pencilSelected = !viewModel.sudokuGameModel.pencilSelected
            pencilButton.isSelected = viewModel.sudokuGameModel.pencilSelected
        case 11 :
            newGameFunc()
        case 12 :
            viewModel.sudokuGameModel.canidates = true
            viewModel.sudokuGameModel.sudoku.generateCandidates(realm: viewModel.sudokuGameModel.realm)
            self.sudokuBoard.reloadData()
        default:
            print("unable to determine click")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (viewModel.sudokuGameModel.newGame) {
            newGameFunc()
        } else {
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        sudokuBoard.delegate = self
        sudokuBoard.dataSource = self
        viewModel.sudokuGameModel.screenSize = self.view.frame
        viewModel.sudokuGameModel.screenWidth = viewModel.sudokuGameModel.screenSize.width/9
        viewModel.sudokuGameModel.screenHeight = viewModel.sudokuGameModel.screenSize.height/9
        sudokuBoard.contentInsetAdjustmentBehavior = .always
        sudokuBoard.register(UINib(nibName:"SudokuBoardElementViewCell", bundle: nil), forCellWithReuseIdentifier: "SudokuCell")
    }
    func loadItems() {
        viewModel.loadItems()
        if (viewModel.sudokuGameModel.sudoku.checkIfSolved()){
            newGameDialog()
        }else if (viewModel.sudokuGameModel.sudoku.isEmpty){
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
    func newGameDialog(){
        let alert = UIAlertController(title: "Game Completed ", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Make new game", style: .default) { [self] (action) in
            self.newGameFunc()
        }
        let cancel = UIAlertAction(title: "Go back", style: .default) { [self] (action) in
            navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func createNewGame(K: Int){
        viewModel.createNewGame(K: K)
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
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(easy)
        alert.addAction(medium)
        alert.addAction(hard)
        alert.addAction(extremlyHard)
        alert.addAction(extreme)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sudokuGameModel.sudoku == nil ? 0 : viewModel.sudokuGameModel.sudoku.getMatBoard().count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return rows
        return viewModel.sudokuGameModel.sudoku == nil ? 0 : viewModel.sudokuGameModel.sudoku.getMatBoard()[section].count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
    UICollectionViewCell {
        if let cell = sudokuBoard.dequeueReusableCell(withReuseIdentifier: "SudokuCell", for: indexPath) as? SudokuBoardElementViewCell{
            cell.layer.borderColor = viewModel.getColor(indexPath: indexPath)
            cell.layer.borderWidth = 1
            
            //setCharacter
            let elment = viewModel.sudokuGameModel.sudoku.getMatBoard()[indexPath.row][indexPath.section]
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
            for highlightedValue in viewModel.sudokuGameModel.highlightedLocations{
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
        viewModel.didSelectItem(indexPath: indexPath)
        self.sudokuBoard.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: viewModel.sudokuGameModel.screenWidth, height: viewModel.sudokuGameModel.screenWidth);
        
    }
}
