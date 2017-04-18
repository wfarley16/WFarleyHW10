//
//  DetailVC.swift
//  WeatherGift
//
//  Created by William Farley on 3/21/17.
//  Copyright © 2017 William Farley. All rights reserved.
//

import UIKit
import CoreLocation

class DetailVC: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        locationsArray[currentPage].getWeather {
            self.updateUserInterface()
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if currentPage == 0 && self.view.window != nil {
            getLocation()
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func updateUserInterface() {
        
        let isHidden = (locationsArray[currentPage].currentTemperature == -999.9)
        
        tempLabel.isHidden = isHidden
        locationLabel.isHidden = isHidden
        currentImage.isHidden = isHidden
        
        let currentTemp = String(format: "%3.f", locationsArray[currentPage].currentTemperature) + "°"
        
        locationLabel.text = locationsArray[currentPage].name
        tempLabel.text = currentTemp
        summaryLabel.text = locationsArray[currentPage].summary
        currentImage.image = UIImage(named: locationsArray[currentPage].currentIcon)
        
        if locationsArray[currentPage].currentTime == 0.0 {
            dateLabel.text = ""
        } else {
            dateLabel.text = formatTimeForTimeZone(unixDateToFormat: locationsArray[currentPage].currentTime, timeZoneString: locationsArray[currentPage].timeZone)
        }
        
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    func formatTimeForTimeZone(unixDateToFormat: TimeInterval, timeZoneString: String) -> String {
        let usableDate = Date(timeIntervalSince1970: unixDateToFormat)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "EEEE, MMM d, y"
        dateFormatter.timeZone = TimeZone(identifier: timeZoneString)
        
        let dateString = dateFormatter.string(from: usableDate)
        
        return dateString
    }
    
}

extension DetailVC: CLLocationManagerDelegate {
    
    func getLocation() {
        let status = CLLocationManager.authorizationStatus()
        handleLocationAuthorizationStatus(status: status)
        
    }
    
    func handleLocationAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied:
            if currentPage == 0 && self.view.window != nil {
                showAlert(title: "User has not authorized location services", message: "Settings > Privacy > Location Services > WeatherGift to enable location services.")
            }
        case .restricted:
            showAlert(title: "Location Services Denied", message: "Parental controls may be restricting location services.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorizationStatus(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if currentPage == 0 && self.view.window != nil {
            
            let geocoder = CLGeocoder()
            
            currentLocation = locations.last
            
            let currentLat = "\(currentLocation.coordinate.latitude)"
            let currentLong = "\(currentLocation.coordinate.longitude)"
            
            var place = ""
            
            geocoder.reverseGeocodeLocation(currentLocation, completionHandler: {placemarks, error in
                if placemarks != nil {
                    let placemark = placemarks!.last
                    place = (placemark?.name!)!
                } else {
                    print("Error retrieving place")
                    place = "Parts Unknown"
                }
                
                self.locationsArray[0].name = place
                self.locationsArray[0].coordinates = currentLat + "," + currentLong
                self.locationsArray[0].getWeather {
                    self.updateUserInterface()
                }
                
            })
            
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location. Error code: \(error)")
    }
}

extension DetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsArray[currentPage].dailyForecastArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayWeatherCell") as! DayWeatherCell
        cell.configureTableCell(dailyForecast: self.locationsArray[currentPage].dailyForecastArray[indexPath.row], timeZone: self.locationsArray[currentPage].timeZone)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}


extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locationsArray[currentPage].hourlyForecastArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hourlyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath) as! HourlyWeatherCell
        hourlyCell.configureCVCell(hourlyForecast: self.locationsArray[currentPage].hourlyForecastArray[indexPath.row], timeZone: self.locationsArray[currentPage].timeZone)
        return hourlyCell
    }
    
}















