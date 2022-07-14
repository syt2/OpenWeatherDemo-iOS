//
//  Model.swift
//  OpenWeatherDemo
//
//  Created by 沈庾涛 on 2022/7/12.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let OpenWeatherModel = try? newJSONDecoder().decode(OpenWeatherModel.self, from: jsonData)

import Foundation


// MARK: - OpenWeatherModel
struct OpenWeatherModel: Codable {
    let lat, lon: Double
    let timezone: String
    let current: Current
    let daily: [Daily]

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone, current, daily
    }
}

// MARK: - Current
struct Current: Codable {
    let dt: Int
    let temp: Double
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case dt, temp, weather
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
    let day, min, max, night: Double
    let eve, morn: Double
}
