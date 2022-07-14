//
//  LocationManager.swift
//  OpenWeatherDemo
//
//  Created by 沈庾涛 on 2022/7/12.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    static let shared = LocationManager()
    
    private var locationManager: CLLocationManager!
    private var requestPermissionCallback: ((Bool) -> Void)?
    private var requestLocationCallback: ((CLLocationCoordinate2D?) -> Void)?
    
    private override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    override func copy() -> Any {
        return self
    }
    
    override func mutableCopy() -> Any {
        return self
    }
    
    /// request location authorization if need
    /// - Parameter completion: completion callback
    func requestPermissionIfNeed(completion: @escaping (Bool) -> Void) {
        guard CLLocationManager.locationServicesEnabled() else {
            completion(false)
            return
        }
        switch authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            requestPermissionCallback = completion
        case .authorizedAlways, .authorizedWhenInUse:
            completion(true)
        default:
            completion(false)
        }
    }
    
    /// request location coordinate
    /// - Parameter completion: complete callback
    func requestLocation(completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        locationManager.requestLocation()
        requestLocationCallback = completion
    }
    
    /// check location authorization
    /// - Returns: has location permission
    func checkPermission() -> Bool {
        guard CLLocationManager.locationServicesEnabled() else {
            return false
        }
        let status = authorizationStatus()
        return status == .authorizedAlways || status == .authorizedWhenInUse
    }
    
    private func authorizationStatus() -> CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return locationManager.authorizationStatus
        } else {
            return CLLocationManager.authorizationStatus()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    /// < ios 14
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let hasPermission = checkPermission()
        requestPermissionCallback?(hasPermission)
        requestPermissionCallback = nil
    }
    
    /// >= ios 14
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let hasPermission = checkPermission()
        requestPermissionCallback?(hasPermission)
        requestPermissionCallback = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        debugPrint(newLocation.coordinate)
        requestLocationCallback?(newLocation.coordinate)
        requestLocationCallback = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
        requestLocationCallback?(nil)
        requestLocationCallback = nil
    }
}


extension LocationManager {
    /// calculate distance between (latA, lonA) and (latB, lonB)
    static func distanceBetween(_ latA: Double, _ lonA: Double, _ latB: Double, _ lonB: Double) -> Double {
        let clLocationA = CLLocation(latitude: latA, longitude: lonA)
        let clLocationB = CLLocation(latitude: latB, longitude: lonB)
        return clLocationA.distance(from: clLocationB)
    }
}
