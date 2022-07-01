//
//  ViewController.swift
//  Clima
// 38f8e4b229f6712a5d1bd16ab89253ad
//this gets me the lat and long https://api.openweathermap.org/geo/1.0/direct?q={London}&appid=38f8e4b229f6712a5d1bd16ab89253ad
// this gets me the weather data https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    var celsius:Bool = true
    @IBOutlet weak var tempValue: UIButton!
    @IBOutlet weak var degreeValue: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    var weatherManager = WeatherManager()
    var temp: Double = 0.0
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        weatherManager.delegate = self
        searchTextField.delegate = self
        
    }
    
    @IBAction func changeUnits(_ sender: UIButton) {
        switch sender.tag{
        case 1,2 :
            DispatchQueue.main.async{
                self.celsius = !self.celsius
                if (self.celsius){
                    self.tempValue.titleLabel?.text = String(self.temp)
                    
                } else {
                    self.tempValue.titleLabel?.text = String((self.temp *  (9/5)) + 32)
                }
                self.degreeValue.titleLabel?.text = self.celsius ? "C" : "F"
            }
        default:
            print("unable to determine click")
        }
    }
}
//MARK: - UITextFieldDelegate
extension WeatherViewController : UITextFieldDelegate{
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
        
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if(textField.text != ""){
            return true
        }else{
            textField.placeholder = "Type something"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
    
}
//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather:WeatherModel) {
        DispatchQueue.main.async{
            self.temp = Double(weather.temperature)!
            if (self.celsius){
                self.tempValue.titleLabel?.text = weather.temperature
            } else {
                self.tempValue.titleLabel?.text = String((Int(weather.temperature)! *  (9/5)) + 32)
            }
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
        
    }
    func didFailWithError(error: Error){
        print(error)
    }
}
//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate{
    @IBAction func RequestCurrentLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(lat: lat, lon: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
