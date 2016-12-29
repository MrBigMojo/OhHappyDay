//
//  OHDConstantsVC.swift
//  OhHappyDay
//
//  Created by Armin Mehinovic on 12/28/16.
//  Copyright © 2016 Armin Mehinovic. All rights reserved.
//

import Foundation

let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
let FORECAST = "http://api.openweathermap.org/data/2.5/forecast/daily?lat="
let CITY_URL = "http://api.openweathermap.org/data/2.5/weather?q="
let CITY_FORECAST = "http://api.openweathermap.org/data/2.5/forecast/daily?q="
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let API_KEY = "&appid=fa6fa3256eb60252dadf7ef78a8e18a9"

typealias DownloadComplete = () -> ()

var CURRENT_WEATHER_URL = "\(BASE_URL)\(LATITUDE)\(Location.sharedInstance.latitude!)\(LONGITUDE)\(Location.sharedInstance.longitude!)\(API_KEY)"
var FORECAST_URL = "\(FORECAST)\(Location.sharedInstance.latitude!)\(LONGITUDE)\(Location.sharedInstance.longitude!)&cnt=10&mode=json\(API_KEY)"
var CITY_WEATHER_URL = "\(CITY_URL)\(selectedCity)\(API_KEY)"
var CITY_FORECAST_URL = "\(CITY_FORECAST)\(selectedCity)\(API_KEY)"
