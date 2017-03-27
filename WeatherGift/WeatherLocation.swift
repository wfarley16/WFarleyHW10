//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by William Farley on 3/27/17.
//  Copyright © 2017 William Farley. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherLocation {
    var name = ""
    var coordinates = ""
    var currentTemperature = -999.9
    var summary = ""
    
    func getWeather(completed: @escaping () -> ()) {
        
        let weatherURL = urlBase + urlAPIKey + coordinates
        
        Alamofire.request(weatherURL).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let temperature = json["currently"]["temperature"].double, let dailySummary = json["daily"]["summary"].string {
                    self.currentTemperature = temperature
                    self.summary = dailySummary
                } else {
                    print("Error returning temperature")
                }
            case .failure(let error):
                print(error)
            }
        }
        
        completed()
    }
}

