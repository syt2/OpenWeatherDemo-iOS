//
//  OpenWeatherDataManager.swift
//  OpenWeatherDemo
//
//  Created by 沈庾涛 on 2022/7/13.
//

import Foundation
import UIKit
import Alamofire

// MARK: open weather url request parameters
private struct requestParameters: Codable {
    var lat, lon: Double
    var units, appid: String
    
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
        units = "metric"
        appid = "4a74170fe5c32cd8c4afb43a38060b1e"
    }
}

class OpenWeatherDataManager {
    private let baseUrl = "https://api.openweathermap.org/data/2.5/onecall"
    /// use cached information if < 1h else request it
    private let requestInterval = 60 * 60.0 // second
    /// as the same location if two location coordinates' distance < 5km
    private let distanceRange = 5 * 1000.0 // meter
    /// record lastest cached information's time
    private var cachedTime: TimeInterval = 0
    /// record lastest cached information's location coordinate
    private var cachedLat: Double = 0
    private var cachedLon: Double = 0
    private(set) var cachedModel: OpenWeatherModel?
    
    init() { }
    
    /// request weather data, if cache information is vaild, use cache information, else request from server
    /// - Parameters:
    ///   - latitude: location latitude
    ///   - longitude: location longitude
    ///   - completion: completion callback
    func requestWeatherData(latitude: Double, longitude: Double, completion: ((OpenWeatherModel?, AFError?) -> Void)?) {
        if let dailyWeatherModel = cachedModel,
           Date().timeIntervalSince1970 - cachedTime < requestInterval,
           LocationManager.distanceBetween(latitude, longitude, cachedLat, cachedLon) < distanceRange {
            completion?(dailyWeatherModel, nil)
            return
        }
        let requestParams = requestParameters(lat: latitude, lon: longitude)
        AF.request(baseUrl, method: .get, parameters: requestParams).responseDecodable { [weak self] (response: AFDataResponse<OpenWeatherModel>) in
            guard let self = self else { return }
            switch response.result {
            case .success(let model):
                debugPrint(model)
                self.cachedTime = Date().timeIntervalSince1970
                self.cachedLat = latitude
                self.cachedLon = longitude
                self.cachedModel = model
                completion?(model, nil)
            case .failure(let error):
                debugPrint(error)
                completion?(nil, error)
            }
        }
    }
    
    /// parse an icon's url
    /// - Parameter icon: icon string from weather model
    /// - Returns: icon url
    static func parseIconUrl(_ icon: String) -> String {
//        let scale = max(min(Int(UIScreen.main.scale), 3), 1)
        let scale = 2 // only 2x png can get
        let urlString = "https://openweathermap.org/img/wn/\(icon)@\(scale)x.png"
        return urlString
    }
}
