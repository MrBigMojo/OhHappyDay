
//
//  OHDWeatherVC.swift
//  OhHappyDay
//
//  Created by Armin Mehinovic on 12/28/16.
//  Copyright © 2016 Armin Mehinovic. All rights reserved.
//

import UIKit
import Alamofire

class OHDCurrentWeather {
    var _cityName: String!
    var _date: String!
    var _weatherType: String!
    var _currentTemp: String!
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today, \(currentDate)"
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemp: String {
        if _currentTemp == nil {
            _currentTemp = "0.0"
        }
        return _currentTemp
    }
    
    func downloadWeatherDetails(completed: @escaping DownloadComplete) {
        Alamofire.request(CURRENT_WEATHER_URL).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized
                    print(self._cityName)
                }
                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                    if let main = weather[0]["main"] as? String {
                        self._weatherType = main.capitalized
                        print(self._weatherType)
                    }
                    
                }
                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    if let currentTemperature = main["temp"] as? Double {
                        let celsiusTemp = currentTemperature - 273.15
                        let roundedTemp = celsiusTemp.roundTo(places: 2)
                        self._currentTemp = "\(roundedTemp)°C"
                    }
                }
            }
            completed()
        }
    }
    
    func downloadSpecificCityWeatherDetails(completed: @escaping DownloadComplete) {
        CITY_WEATHER_URL = "\(CITY_URL)\(selectedCity)\(API_KEY)"
        Alamofire.request(CITY_WEATHER_URL).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized
                    print(self._cityName)
                }
                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                    if let main = weather[0]["main"] as? String {
                        self._weatherType = main.capitalized
                        print(self._weatherType)
                    }
                }
                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    if let currentTemperature = main["temp"] as? Double {
                        let celsiusTemp = currentTemperature - 273.15
                        let roundedTemp = celsiusTemp.roundTo(places: 2)
                        self._currentTemp = "\(roundedTemp)°C"
                    }
                }
            }
            completed()
        }
    }
}

