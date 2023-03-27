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
        if (sender.tag == newGame.tag){
            newGameBoolean = true
            
        } else if (sender.tag == loadGame.tag){
            newGameBoolean = false
        }
        self.performSegue(withIdentifier: "ShowBoard", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SudokuBoardViewController
        let viewModel = SudokuGameModel()
        viewModel.newGame = newGameBoolean
        vc.viewModel = viewModel
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
