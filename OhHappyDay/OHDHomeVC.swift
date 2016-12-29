//
//  OHDHomeVC.swift
//  OhHappyDay
//
//  Created by Armin Mehinovic on 12/28/16.
//  Copyright © 2016 Armin Mehinovic. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

var selectedCity = ""

class OHDHomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var otherCitiesTextView: UITextField!
    @IBOutlet weak var dismissKeyBoardAndLayer: UIButton!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var currentWeather: OHDCurrentWeather!
    var forecast: OHDForecast!
    var forecasts = [OHDForecast]()
    
    //MARK: viewLoader methods
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        currentWeather = OHDCurrentWeather()
        otherCitiesTextView.isHidden = true
        dismissKeyBoardAndLayer.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    
    //MARK: Location Manager
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            currentWeather.downloadWeatherDetails {
                self.downloadForecastData {
                    self.updateMainUI()
                }
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
    
    func updateMainUI() {
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)"
        currentWeatherTypeLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }
    
    //MARK: Weather data downloading and parsing
    func downloadForecastData(completed: @escaping DownloadComplete) {
        Alamofire.request(FORECAST_URL).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    for obj in list {
                        let forecast = OHDForecast(weatherDict: obj)
                        self.forecasts.append(forecast)
                        print(obj)
                    }
                    self.forecasts.remove(at: 0)
                    self.tableView.reloadData()
                }
            }
            completed()
        }
    }
    
    func downloadCityForeCastData(completed: @escaping DownloadComplete) {
        CITY_FORECAST_URL = "\(CITY_FORECAST)\(selectedCity)\(API_KEY)"
        Alamofire.request(CITY_FORECAST_URL).responseJSON { response in
            self.forecasts.removeAll()
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    for obj in list {
                        let forecast = OHDForecast(weatherDict: obj)
                        self.forecasts.append(forecast)
                        print(obj)
                    }
                }
                self.tableView.reloadData()
            }
            completed()
        }
    }
    
    //MARK: tableView manipulation
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? OHDWeatherCell {
            let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            return cell
        } else {
            return OHDWeatherCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0.5
        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 0, 0)
        cell.layer.transform = transform
        UIView.animate(withDuration: 1.0) {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    //MARK: textField manipulation
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        otherCitiesTextView.isHidden = true
        otherCitiesTextView.resignFirstResponder()
        dismissKeyBoardAndLayer.isHidden = true
        if let selectedCityText = otherCitiesTextView.text {
            selectedCity = selectedCityText
        }
        currentWeather.downloadSpecificCityWeatherDetails {
            self.downloadCityForeCastData {
                self.updateMainUI()
            }
        }
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //MARK: IBActions
    @IBAction func otherCitiesButton(_ sender: AnyObject) {
        otherCitiesTextView.isHidden = false
        otherCitiesTextView.becomeFirstResponder()
        dismissKeyBoardAndLayer.isHidden = false
    }
    
    @IBAction func dismissButton(_ sender: AnyObject) {
        otherCitiesTextView.isHidden = true
        otherCitiesTextView.resignFirstResponder()
        dismissKeyBoardAndLayer.isHidden = true
        if let selectedCityText = otherCitiesTextView.text {
            selectedCity = selectedCityText
        }
        currentWeather.downloadSpecificCityWeatherDetails {
            self.downloadCityForeCastData {
                self.updateMainUI()
            }
        }
    }
}

