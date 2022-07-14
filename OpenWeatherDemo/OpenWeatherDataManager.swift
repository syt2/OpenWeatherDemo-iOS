//
//  OpenWeatherDataManager.swift
//  OpenWeatherDemo
//
//  Created by 沈庾涛 on 2022/7/13.
//

import Foundation
import UIKit
import Alamofire

class OpenWeatherDataManager {
    private static let baseUrl = "https://api.openweathermap.org/data/2.5/onecall"
    private static let appid = "4a74170fe5c32cd8c4afb43a38060b1e"
    
    private static let requestInterval = 5 * 60.0 // second
    private static let distanceRange = 5 * 1000.0 // meter

    static let shared = OpenWeatherDataManager()
    
    private var cachedTime: TimeInterval = 0
    private var cachedLat: Double = 0
    private var cachedLon: Double = 0
    private(set) var dailyWeatherModel: OpenWeatherModel?
    
    private init() { }
    
    func requestWeatherData(latitude: Double, longitude: Double, completion: ((OpenWeatherModel?, AFError?) -> Void)?) {
        if let dailyWeatherModel = dailyWeatherModel,
           Date().timeIntervalSince1970 - cachedTime < Self.requestInterval,
           LocationManager.distanceBetween(latitude, longitude, cachedLat, cachedLon) < Self.distanceRange {
            completion?(dailyWeatherModel, nil)
            return
        }
        let requestUrl = constructRequestUrl(latitude: latitude, longitude: longitude)
        AF.request(requestUrl).responseDecodable(of: OpenWeatherModel.self) { [unowned self] response in
            switch response.result {
            case .success(let model):
                debugPrint(model)
                self.cachedTime = Date().timeIntervalSince1970
                self.cachedLat = latitude
                self.cachedLon = longitude
                self.dailyWeatherModel = model
                completion?(model, nil)
            case .failure(let error):
                debugPrint(error)
                completion?(nil, error)
            }
        }
    }
    
    static func parseIconUrl(_ icon: String) -> String {
//        let scale = max(min(Int(UIScreen.main.scale), 3), 1)
        let scale = 2 // only 2x png can get
        let urlString = "https://openweathermap.org/img/wn/\(icon)@\(scale)x.png"
        return urlString
    }
    
    private func constructRequestUrl(latitude: Double, longitude: Double) -> String {
        let url = "\(Self.baseUrl)?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(Self.appid)"
        return url
    }
}
