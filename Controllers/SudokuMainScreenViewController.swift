//
//  SudokuMainScreenViewController.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 5/23/22.
//

import UIKit

class SudokuMainScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func sudokuGame(){
        let N:Int = 9
        let K:Int = 20
        let sudoku = Sudoku(numberOfRowsColumns: N, numberOfMissingDigits: K);
        sudoku.fillValues();
        sudoku.printBoard();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sudokuGame()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
