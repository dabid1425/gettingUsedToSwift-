//
//  SudokuMainScreenViewController.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 5/23/22.
//

import UIKit

class SudokuMainScreenViewController: UIViewController {
    
    @IBOutlet weak var loadGame: UIButton!
    @IBOutlet weak var newGame: UIButton!
    var newGameBoolean:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        newGameBoolean = sender.tag == newGame.tag
        self.performSegue(withIdentifier: "ShowBoard", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SudokuBoardViewController
        let viewModel = SudokuGameViewModel()
        viewModel.sudokuGameModel.newGame = newGameBoolean
        vc.viewModel = viewModel
    }
    
}
