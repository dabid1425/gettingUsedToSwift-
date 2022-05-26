//
//  TipCalViewController.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 3/30/21.
//

import UIKit

class TipCalViewController: UIViewController {

    @IBOutlet weak var billAmount: UITextField!
    @IBOutlet weak var tipPercentage: UITextField!
    @IBOutlet weak var tipAmount: UITextField!
    @IBOutlet weak var billTotal: UITextField!
    var calc = Calculator()
    var oneHundo = 100
    var one = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func calcTip(_ sender: Any) {
        let billAmountText = billAmount.text ?? ""
        let billAmountAsDouble = Double(billAmountText) ?? -1
        let tipPercentageText = tipPercentage.text ?? ""
        var tipPercentagetAsDouble = Double(tipPercentageText) ?? -1
        if(billAmountAsDouble < 0  || tipPercentagetAsDouble < 0){
            tipAmount.text = "0.0"
            billAmount.text = "0.0"
            tipPercentage.text = "0.0"
            billTotal.text = "0.0"
        }else{
            if(tipPercentagetAsDouble > 1){
                tipPercentagetAsDouble = calc.divide(var1: tipPercentagetAsDouble, var2: Double(oneHundo))
            }
            
            tipAmount.text = String(calc.multiply(var1: billAmountAsDouble, var2: tipPercentagetAsDouble))
            billTotal.text = String(calc.multiply(var1: billAmountAsDouble, var2: calc.add(var1: Double(one), var2: tipPercentagetAsDouble)))
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

}
