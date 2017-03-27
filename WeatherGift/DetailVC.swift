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
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var currentImage: UIImageView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        if currentPage == 0 {
            getLocation()
        }

        updateUserInterface()
        
    }
    
    func updateUserInterface() {
        locationLabel.text = locationsArray[currentPage].name
        dateLabel.text = locationsArray[currentPage].coordinates
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
        
        print("Coordinates are: " + currentLat + currentLong)
        
        var place = ""
        
        geocoder.reverseGeocodeLocation(currentLocation, completionHandler: {placemarks, error in
            if placemarks != nil {
                let placemark = placemarks!.last
                place = (placemark?.name!)!
            } else {
                print("Error retrieving place. Error code: \(error)")
            }
            
            print(place)
            self.locationsArray[0].name = place
            self.locationsArray[0].coordinates = currentLat + " , " + currentLong
            self.updateUserInterface()
        })
        
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location. Error code: \(error)")
    }
}












