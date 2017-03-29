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
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        if currentPage == 0 {
            getLocation()
        }
        
        locationsArray[currentPage].getWeather {
            self.updateUserInterface()
        }
        
    }
    
    func updateUserInterface() {
        
        let isHidden = (locationsArray[currentPage].currentTemperature == -999.0)
        
        tempLabel.isHidden = isHidden
        locationLabel.isHidden = isHidden
        
        locationLabel.text = locationsArray[currentPage].name
        dateLabel.text = locationsArray[currentPage].coordinates
        
        let currentTemp = String(format: "%3.f", locationsArray[currentPage].currentTemperature) + "°"
        
        tempLabel.text = currentTemp
        summaryLabel.text = locationsArray[currentPage].summary
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
            print("I'm sorry - I can't show location. User has not authorized it.")
        case .restricted:
            print("Access denied - likelt parental controllers are restricting location use in this app.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorizationStatus(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if currentPage == 0 {
        
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
                print("Error retrieving place. Error code: \(error)")
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












