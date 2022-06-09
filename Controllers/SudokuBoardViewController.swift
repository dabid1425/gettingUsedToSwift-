//
//  SudokuBoardViewController.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 5/26/22.
//

import UIKit
import RealmSwift
class SudokuBoardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
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
            
            
            //sudoku.printBoard();
        } else {
            loadItems()
        }
    }
    
    func loadItems(){
        
        sudokuGame = realm.objects(SudokuRow.self)
        self.sudokuBoard.reloadData()
        
        //USING COREDATA
        //        let request : NSFetchRequest<Category> = Category.fetchRequest()
        //        do{
        //            categories =  try context.fetch(request)
        //            self.tableView.reloadData()
        //        }catch{
        //
        //        }
    }
    
    func saveData(sudokuGame: SudokuRow){
        //Using Realm
        do{
            try realm.write(){
                realm.add(sudokuGame)
            }
            
        }catch{
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
            //setCharacter
            cell.setLabel(label: String(sudoku.getMatBoard()[indexPath.section][indexPath.item].boxValue))
            return cell
        }
        let cell = sudokuBoard.dequeueReusableCell(withReuseIdentifier: "SudokuCell", for: indexPath)
        cell.backgroundColor = UIColor.green
        return cell
    }
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */

//extension SudokuBoardViewController:  UICollectionViewDataSource{
//
//
//
//
//
//       override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
//           cell.backgroundColor = UIColor.orange
//           return cell
//       }
//}
