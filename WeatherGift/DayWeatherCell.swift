//
//  DayWeatherCell.swift
//  
//
//  Created by William Farley on 4/3/17.
//
//

import UIKit

class DayWeatherCell: UITableViewCell {

    @IBOutlet weak var cellIcon: UIImageView!
    @IBOutlet weak var cellWeekday: UILabel!
    @IBOutlet weak var cellMaxTemp: UILabel!
    @IBOutlet weak var cellMinTemp: UILabel!
    @IBOutlet weak var cellSummary: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureTableCell(dailyForecast: WeatherLocation.DailyForecast, timeZone: String) {
        cellMaxTemp.text = String(format: "%2.f", dailyForecast.dailyMaxTemp) + "°"
        cellMinTemp.text = String(format: "%2.f", dailyForecast.dailyMinTemp) + "°"
        cellSummary.text = dailyForecast.dailySummary
        cellIcon.image = UIImage(named: dailyForecast.dailyIcon)
        
        let dailyTimeZone = TimeZone(identifier: timeZone)
        
        let usableDate = Date(timeIntervalSince1970: dailyForecast.dailyDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.timeZone = dailyTimeZone
        let weekDay = dateFormatter.string(from: usableDate as Date)
        cellWeekday.text = weekDay
    }

}
