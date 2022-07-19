//
//  WeatherManager.swift
//  Clima
//
//  Created by Dan Abid on 4/8/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//
import CoreLocation
import Foundation
protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather:WeatherModel)
    func didFailWithError(error: Error)
}
struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=38f8e4b229f6712a5d1bd16ab89253ad&units=metric"
    // this gets me the weather data https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
    var delegate: WeatherManagerDelegate?
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        if let urlSpaceHandleString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            performRequest(with:urlSpaceHandleString )
        }
    }
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(with: urlString)
    }
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            let urlSession = URLSession(configuration: .default)
            
            let task = urlSession.dataTask(with: url) { data, response, error in
                if(error != nil){
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let saveData = data{
                    if let weather = self.passJSON(saveData){
                        self.delegate?.didUpdateWeather(self, weather:weather)
                    }
                }
            }
            task.resume()
        }
    }
    func passJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, cityName: name, temp: temp)
            return weather
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
