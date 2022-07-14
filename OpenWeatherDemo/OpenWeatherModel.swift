//
//  Model.swift
//  OpenWeatherDemo
//
//  Created by 沈庾涛 on 2022/7/12.
//

import Foundation

// MARK: - OpenWeatherModel
struct OpenWeatherModel: Codable {
    let lat, lon: Double
    let current: Current
    let daily: [Daily]

    enum CodingKeys: String, CodingKey {
        case lat, lon, current, daily
    }
}

// MARK: - Current
struct Current: Codable {
    let dt: Double
    let temp: Double
    let weatherArray: [Weather]

    enum CodingKeys: String, CodingKey {
        case dt, temp
        case weatherArray = "weather"
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: String
    let weatherDescription: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}


// MARK: - Daily
struct Daily: Codable {
    let dt: Double
    let temp: Temperature
    let weatherArray: [Weather]
    let rain: Double?

    enum CodingKeys: String, CodingKey {
        case dt, temp
        case weatherArray = "weather"
        case rain
        
    }
}

// MARK: - Temperature
struct Temperature: Codable {
    let min, max: Double
}
