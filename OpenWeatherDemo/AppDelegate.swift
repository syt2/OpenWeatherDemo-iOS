//
//  AppDelegate.swift
//  OpenWeatherDemo
//
//  Created by 沈庾涛 on 2022/7/12.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootVC = ViewController()
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.navigationBar.isTranslucent = false
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        return true
    }
}

