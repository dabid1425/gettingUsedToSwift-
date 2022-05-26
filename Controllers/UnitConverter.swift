//
//  UnitConverter.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 5/11/21.
//

import Foundation
class UnitConverter {
    
    let conversionUnitTypes = ["Distance","Duration","Mass","Temperature","Volume","Speed","Area","Angle"]
    
    let distanceUnitList = [UnitLength.astronomicalUnits, UnitLength.centimeters, UnitLength.feet, UnitLength.inches, UnitLength.kilometers, UnitLength.lightyears, UnitLength.meters, UnitLength.miles, UnitLength.millimeters, UnitLength.parsecs, UnitLength.yards]
    
    let durationUnitList = [UnitDuration.hours, UnitDuration.minutes, UnitDuration.seconds]
    
    let massUnitList = [UnitMass.grams, UnitMass.kilograms, UnitMass.ounces, UnitMass.pounds, UnitMass.stones, UnitMass.metricTons]
    
    let tempUnitList = [UnitTemperature.celsius, UnitTemperature.fahrenheit, UnitTemperature.kelvin]
    
    let volumeUnitList = [UnitVolume.bushels, UnitVolume.cubicFeet, UnitVolume.cups, UnitVolume.fluidOunces, UnitVolume.gallons, UnitVolume.liters, UnitVolume.milliliters, UnitVolume.pints, UnitVolume.quarts, UnitVolume.tablespoons, UnitVolume.teaspoons]
     
    let speedUnitList = [UnitSpeed.kilometersPerHour, UnitSpeed.knots, UnitSpeed.metersPerSecond,UnitSpeed.metersPerSecond]
    
    let areaUnitList = [UnitArea.ares, UnitArea.squareCentimeters,UnitArea.squareFeet,UnitArea.squareInches,UnitArea.squareKilometers,UnitArea.squareMeters]
    
    let angleUnitList = [UnitAngle.degrees,UnitAngle.radians,UnitAngle.arcMinutes,UnitAngle.arcSeconds]
    
    func getConversionsUnitTypesList() ->  [String] {
        return conversionUnitTypes
    }
    
    func getDurationUnitList() -> [UnitDuration] {
        return durationUnitList
    }
    
    func getDistanceConversionsList() ->  [UnitLength] {
        return distanceUnitList
    }
    
    func getMassConversionsList() ->  [UnitMass] {
        return massUnitList
    }
    
    func getTempConversionsList() ->  [UnitTemperature] {
        return tempUnitList
    }
    
    func getVolumeConversionsList() ->  [UnitVolume] {
        return volumeUnitList
    }
    
    func getSpeedConversionsList() ->  [UnitSpeed] {
        return speedUnitList
    }
    
    func getAreaUnitList() ->  [UnitArea] {
        return areaUnitList
    }
    func getAngleUnitList() ->  [UnitAngle] {
        return angleUnitList
    }
    
    func getDurationUnitValue(row : Int) -> UnitDuration {
        return durationUnitList[row]
    }
    
    func getDistanceUnitValue(row : Int) ->  UnitLength {
        return distanceUnitList[row]
    }
    
    func getMassUnitValue(row : Int) ->  UnitMass {
        return massUnitList[row]
    }
    
    func getTempUnitValue(row : Int) ->  UnitTemperature {
        return tempUnitList[row]
    }
    
    func getVolumeUnitValue(row : Int) ->  UnitVolume {
        return volumeUnitList[row]
    }
    
    func getSpeedUnitValue(row : Int) ->  UnitSpeed {
        return speedUnitList[row]
    }
    
    func getAreaUnitValue(row : Int) ->  UnitArea {
        return areaUnitList[row]
    }
    func getAngleUnitValue(row : Int) ->  UnitAngle {
        return angleUnitList[row]
    }
    
    func convertUnitDistance(_ value: Double, from sourceUnit: UnitLength, to targetUnit: UnitLength) -> Double {
        let a = Measurement(value: value, unit: sourceUnit)
        let b = a.converted(to: targetUnit).value
        return b
    }
    func convertUnitDuration(_ value: Double, from sourceUnit: UnitDuration, to targetUnit: UnitDuration) -> Double {
        let a = Measurement(value: value, unit: sourceUnit)
        let b = a.converted(to: targetUnit).value
        return b
    }
    
    func convertUnitMass(_ value: Double, from sourceUnit: UnitMass, to targetUnit: UnitMass) -> Double {
        let a = Measurement(value: value, unit: sourceUnit)
        let b = a.converted(to: targetUnit).value
        return b
    }
    
    func convertUnitTemperature(_ value: Double, from sourceUnit: UnitTemperature, to targetUnit: UnitTemperature) -> Double {
        let a = Measurement(value: value, unit: sourceUnit)
        let b = a.converted(to: targetUnit).value
        return b
    }
    
    func convertUnitVolume(_ value: Double, from sourceUnit: UnitVolume, to targetUnit: UnitVolume) -> Double {
        let a = Measurement(value: value, unit: sourceUnit)
        let b = a.converted(to: targetUnit).value
        return b
    }
    func convertUnitSpeed(_ value: Double, from sourceUnit: UnitSpeed, to targetUnit: UnitSpeed) -> Double {
        let a = Measurement(value: value, unit: sourceUnit)
        let b = a.converted(to: targetUnit).value
        return b
    }
    func convertUnitArea(_ value: Double, from sourceUnit: UnitArea, to targetUnit: UnitArea) -> Double {
        let a = Measurement(value: value, unit: sourceUnit)
        let b = a.converted(to: targetUnit).value
        return b
    }
    func convertUnitAngle(_ value: Double, from sourceUnit: UnitAngle, to targetUnit: UnitAngle) -> Double {
        let a = Measurement(value: value, unit: sourceUnit)
        let b = a.converted(to: targetUnit).value
        return b
    }
}

