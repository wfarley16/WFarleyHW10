//
//  HourlyWeatherCell.swift
//  WeatherGift
//
//  Created by William Farley on 4/17/17.
//  Copyright © 2017 William Farley. All rights reserved.
//

import UIKit

class HourlyWeatherCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var raindropIcon: UIImageView!
    @IBOutlet weak var precipProbLabel: UILabel!
    
    func configureCVCell(hourlyForecast: WeatherLocation.HourlyForecast, timeZone: String) {
        tempLabel.text = String(format: "%2.f", hourlyForecast.hourlyTemp) + "°"
        weatherIcon.image = UIImage(named: "small-" + hourlyForecast.hourlyIcon)
        precipProbLabel.text = String(format: "%2.f", hourlyForecast.hourlyPrecipProb * 100) + "%"
        
        let isHidden = !(hourlyForecast.hourlyPrecipProb >= 0.30 || hourlyForecast.hourlyIcon == "rain")
        
        raindropIcon.isHidden = isHidden
        precipProbLabel.isHidden = isHidden
        
        let usableDate = Date(timeIntervalSince1970: hourlyForecast.hourlyTime)
        let hourlyTimeZone = TimeZone(identifier: timeZone)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ha"
        dateFormatter.timeZone = hourlyTimeZone
        let hour = dateFormatter.string(from: usableDate as Date)
        timeLabel.text = hour
    }
    
}
