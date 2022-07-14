//
//  OpenWeatherModel+Extension.swift
//  OpenWeatherDemo
//
//  Created by 沈庾涛 on 2022/7/13.
//

import Foundation

extension Daily {
    var dateText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "📅 yyyy-MM-dd EEEE"
        let date = Date(timeIntervalSince1970: dt)
        return dateFormatter.string(from: date)
    }
    
    var temperatureText: String {
        "🌡️ \(Int(temp.min + 0.5))°C ～ \(Int(temp.max + 0.5))°C"
    }
    
    var weather: Weather? {
        weatherArray.last
    }
    
    var detailText: String {
        weather?.weatherDescription ?? ""
    }
}

extension Weather {
    var iconUrl: URL? {
        URL(string: OpenWeatherDataManager.parseIconUrl(icon))
    }
}
