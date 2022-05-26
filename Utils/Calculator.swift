//
//  Calculator.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 5/11/21.
//

import Foundation
class Calculator {
    
    func divide(var1:Double, var2:Double) -> Double {
        return var1 / var2
    }
    func multiply(var1:Double, var2:Double) -> Double {
        return var1 * var2
    }
    func add(var1:Double, var2:Double) -> Double {
        return var1 + var2
    }
    func subtract(var1:Double, var2:Double) -> Double {
        return var1 - var2
    }
    func double(fraction fractionString:String)->Double!{
            let separators = CharacterSet(charactersIn: "/")
            let components = fractionString.components(separatedBy: separators)
            if components.count >= 2{
                guard  let numerator = Double(components[0]) else {return -1}
                guard  let denominator = Double(components[1]) else {return -1}
                if (denominator > 0 && numerator >= 0){
                    return numerator/denominator
                } else {return nil} //division by zero will result in zero
            }
            return nil
        }
    
}
