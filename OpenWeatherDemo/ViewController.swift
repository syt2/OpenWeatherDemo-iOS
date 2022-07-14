//
//  ViewController.swift
//  OpenWeatherDemo
//
//  Created by 沈庾涛 on 2022/7/12.
//

import UIKit
import Alamofire
import Masonry

class ViewController: UIViewController {
    private var dailyWeatherView: DailyWeatherView!
    private var dailyModels: [Daily]? {
        didSet {
            dailyWeatherView.dailyModels = dailyModels
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configNavRightButton()
        configView()
    }
    
    private func configView() {
        dailyWeatherView = DailyWeatherView()
        view.addSubview(dailyWeatherView)
        dailyWeatherView.mas_makeConstraints { make in
            make?.edges.equalTo()(view)
        }
        dailyWeatherView.selectCallback = { [weak self] index in
            guard let self = self,
                  let dailyModels = self.dailyModels,
                  index >= 0 && index < dailyModels.count else {
                return
            }
            let vc = DailyDetailViewController(model: dailyModels[index])
            self.present(vc, animated: true)
        }
    }
}

extension ViewController {
    func configNavRightButton() {
        let rightButton = UIBarButtonItem(title: "refresh", style: .plain, target: self, action: #selector(requestLocationPermission))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func requestLocationPermission() {
        /// reload daily models
        dailyModels = nil
        /// request location authorization
        LocationManager.shared.requestPermissionIfNeed { hasPermission in
            guard hasPermission else { return }
            /// request location coordinate
            LocationManager.shared.requestLocation { [weak self] coordinate in
                guard let self = self, let coordinate = coordinate else { return }
                /// request weather data
                OpenWeatherDataManager.shared.requestWeatherData(latitude: coordinate.latitude, longitude: coordinate.longitude) { [weak self] model, error in
                    guard let self = self, error == nil, let model = model else { return }
                    self.dailyModels = model.daily
                }
            }
        }
    }
    
}


