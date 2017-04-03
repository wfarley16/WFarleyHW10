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
    
    struct DailyForecast {
        var dailyMaxTemp: Double
        var dailyMinTemp: Double
        var dailySummary: String
        var dailyDate: Double
        var dailyIcon: String
    }
    
    var name = ""
    var coordinates = ""
    var currentTemperature = -999.9
    var summary = ""
    var currentIcon = ""
    var currentTime = 0.0
    var timeZone = ""
    var dailyForecastArray = [DailyForecast]()
    
    func getWeather(completed: @escaping () -> ()) {
        
        let weatherURL = urlBase + urlAPIKey + coordinates
        
        Alamofire.request(weatherURL).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let dailyDataArray = json["daily"]["data"]
                
                self.dailyForecastArray = []
                
                let lastDay = min(dailyDataArray.count-1, 6)
                
                for day in 1...lastDay {
                    let maxTemp = json["daily"]["data"][day]["temperatureMax"].doubleValue
                    let minTemp = json["daily"]["data"][day]["temperatureMin"].doubleValue
                    let dailySummary = json["daily"]["data"][day]["summary"].stringValue
                    let dateValue = json["daily"]["data"][day]["time"].doubleValue
                    let icon = json["daily"]["data"][day]["icon"].stringValue
                    let iconName = icon.replacingOccurrences(of: "night", with: "day")
                    self.dailyForecastArray.append(DailyForecast(dailyMaxTemp: maxTemp, dailyMinTemp: minTemp, dailySummary: dailySummary, dailyDate: dateValue, dailyIcon: iconName))
                }
                
                if let temperature = json["currently"]["temperature"].double, let dailySummary = json["daily"]["summary"].string, let icon = json["currently"]["icon"].string, let time = json["currently"]["time"].double, let timeZone = json["timezone"].string {
                    self.currentTemperature = temperature
                    self.summary = dailySummary
                    self.currentIcon = icon
                    self.currentTime = time
                    self.timeZone = timeZone
                    } else {
                    print("Error returning json information")
                }
            case .failure(let error):
                print(error)
            }
        }
        
        completed()
    }
}

