//
//  UnitConverterViewController.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 5/11/21.
//

import UIKit

class UnitConverterViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
   
    @IBOutlet weak var convertedValue: UITextField!
    
    @IBOutlet weak var originalValueText: UITextField!
    
    @IBOutlet weak var unitPickerText: UITextField!
    
    @IBOutlet weak var unitSymbol: UITextField!
    
    @IBOutlet weak var convertedUnitSymbol: UITextField!
    
    var pickerDataCategory: [String] = UnitConverter().getConversionsUnitTypesList()
    
    let unitPicker  = UIPickerView()
    let dimensionPicker = UIPickerView()
    let convertedDimensionPicker = UIPickerView()
    
    var unitCategoryIndex : Int = 0
    
    var originalUnitIndex : Int = 0
    
    var convertedUnitIndex : Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        unitPicker.dataSource = self
        unitPicker.delegate = self
        
        dimensionPicker.dataSource = self
        dimensionPicker.delegate = self
        
        convertedDimensionPicker.dataSource = self
        convertedDimensionPicker.delegate = self
       
        unitPickerText.inputView = unitPicker
        
        unitSymbol.inputView = dimensionPicker
        
        convertedUnitSymbol.inputView = convertedDimensionPicker
        
        
    }
    
    @IBAction func convertOrigialToNew(_ sender: Any) {
        let calc = Calculator()
        let originalValue = originalValueText.text ?? ""
        let originalValueAsDouble = calc.double(fraction: originalValue) ?? -1
        if(originalValueAsDouble < 0 ){
            originalValueText.text = "0.0"
            convertedValue.text = "0.0"
        }else{
            if(unitCategoryIndex == 0){
                convertedValue.text = String(UnitConverter().convertUnitDistance(originalValueAsDouble, from: UnitConverter().getDistanceUnitValue(row: originalUnitIndex), to: UnitConverter().getDistanceUnitValue(row: convertedUnitIndex)))
            }else if(unitCategoryIndex == 1){
                convertedValue.text = String(UnitConverter().convertUnitDuration(originalValueAsDouble, from: UnitConverter().getDurationUnitValue(row: originalUnitIndex), to: UnitConverter().getDurationUnitValue(row: convertedUnitIndex)))
                
            }else if(unitCategoryIndex == 2){
                convertedValue.text = String(UnitConverter().convertUnitMass(originalValueAsDouble, from: UnitConverter().getMassUnitValue(row: originalUnitIndex), to: UnitConverter().getMassUnitValue(row: convertedUnitIndex)))
            }else if(unitCategoryIndex == 3){
                convertedValue.text = String(UnitConverter().convertUnitTemperature(originalValueAsDouble, from: UnitConverter().getTempUnitValue(row: originalUnitIndex), to: UnitConverter().getTempUnitValue(row: convertedUnitIndex)))
            }else if(unitCategoryIndex == 4){
                convertedValue.text = String(UnitConverter().convertUnitVolume(originalValueAsDouble, from: UnitConverter().getVolumeUnitValue(row: originalUnitIndex), to: UnitConverter().getVolumeUnitValue(row: convertedUnitIndex)))
            }else if(unitCategoryIndex == 5){
                convertedValue.text = String(UnitConverter().convertUnitSpeed(originalValueAsDouble, from: UnitConverter().getSpeedUnitValue(row: originalUnitIndex), to: UnitConverter().getSpeedUnitValue(row: convertedUnitIndex)))
            }else if(unitCategoryIndex == 6){
                convertedValue.text = String(UnitConverter().convertUnitArea(originalValueAsDouble, from: UnitConverter().getAreaUnitValue(row: originalUnitIndex), to: UnitConverter().getAreaUnitValue(row: convertedUnitIndex)))
            }else if(unitCategoryIndex == 7){
                convertedValue.text = String(UnitConverter().convertUnitAngle(originalValueAsDouble, from: UnitConverter().getAngleUnitValue(row: originalUnitIndex), to: UnitConverter().getAngleUnitValue(row: convertedUnitIndex)))
            }
            
        }
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func getUnitString(row: Int) -> String {
        unitCategoryIndex = row
        var titleRow = UnitConverter().getDistanceConversionsList()[row].symbol
       if unitPickerText.text ==  pickerDataCategory[1]{
            titleRow = UnitConverter().getDurationUnitList()[row].symbol
        }else if unitPickerText.text ==  pickerDataCategory[2]{
            titleRow = UnitConverter().getMassConversionsList()[row].symbol
        }else if unitPickerText.text ==  pickerDataCategory[3]{
            titleRow = UnitConverter().getTempConversionsList()[row].symbol
        }else if unitPickerText.text ==  pickerDataCategory[4]{
            titleRow = UnitConverter().getVolumeConversionsList()[row].symbol
        }else if unitPickerText.text ==  pickerDataCategory[5]{
            titleRow = UnitConverter().getSpeedConversionsList()[row].symbol
        }else if unitPickerText.text ==  pickerDataCategory[6]{
            titleRow = UnitConverter().getAreaUnitList()[row].symbol
        }else if unitPickerText.text ==  pickerDataCategory[7]{
            titleRow = UnitConverter().getAngleUnitList()[row].symbol
        }
        return titleRow
    }
    
    func getUnitCount(row: Int) -> Int {
        var countrows = UnitConverter().getDistanceConversionsList().count
        if unitPickerText.text ==  pickerDataCategory[1]{
            countrows = UnitConverter().getDurationUnitList().count
        }else if unitPickerText.text ==  pickerDataCategory[2]{
            countrows = UnitConverter().getMassConversionsList().count
        }else if unitPickerText.text ==  pickerDataCategory[3]{
            countrows = UnitConverter().getTempConversionsList().count
        }else if unitPickerText.text ==  pickerDataCategory[4]{
            countrows = UnitConverter().getVolumeConversionsList().count
        }else if unitPickerText.text ==  pickerDataCategory[5]{
            countrows = UnitConverter().getSpeedConversionsList().count
        }else if unitPickerText.text ==  pickerDataCategory[6]{
            countrows = UnitConverter().getAreaUnitList().count
        }else if unitPickerText.text ==  pickerDataCategory[7]{
            countrows = UnitConverter().getAngleUnitList().count
        }
        return countrows
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var countrows : Int = pickerDataCategory.count
        if pickerView == dimensionPicker ||  pickerView == convertedDimensionPicker{
            countrows = getUnitCount(row: component)
            }
        return countrows
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == unitPicker {
            let titleRow = pickerDataCategory[row]
            return titleRow
        } else if pickerView == dimensionPicker ||  pickerView == convertedDimensionPicker{
            return getUnitString(row: row)
        }

        return ""
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == unitPicker {
            self.unitPickerText.text = self.pickerDataCategory[row]

            self.view.endEditing(true)

        } else if pickerView == dimensionPicker{
            self.unitSymbol.text = getUnitString(row: row)
            originalUnitIndex = row
            
            if(self.convertedUnitSymbol.text == "" || self.unitSymbol.text == self.convertedUnitSymbol.text){
                if(row + 1 == getUnitCount(row: row)){
                    self.convertedUnitSymbol.text = getUnitString(row: row - 1)
                    convertedUnitIndex = row - 1
                }else{
                    self.convertedUnitSymbol.text = getUnitString(row: row + 1)
                    convertedUnitIndex = row + 1
                }
                
            }
                
            self.view.endEditing(true)
        }else if pickerView == convertedDimensionPicker {
            self.convertedUnitSymbol.text = getUnitString(row: row)
            convertedUnitIndex = row
            if(self.unitSymbol.text == "" || self.unitSymbol.text == self.convertedUnitSymbol.text){
                if(row + 1 == getUnitCount(row: row)){
                    self.unitSymbol.text = getUnitString(row: row - 1)
                    originalUnitIndex = row - 1
                }else{
                    self.unitSymbol.text = getUnitString(row: row + 1)
                    originalUnitIndex = row + 1
                }
                
            }
            
            self.view.endEditing(true)
        }
    }

}
