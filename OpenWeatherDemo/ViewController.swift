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
    private let dataManager: OpenWeatherDataManager
    private var weatherModel: OpenWeatherModel? {
        didSet {
            weatherView.model = weatherModel
        }
    }
    /// record request state currently
    private var requestIdle = true {
        didSet {
            configNavRightButton()
        }
    }
    
    private var weatherView: WeatherView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        dataManager = OpenWeatherDataManager()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configNavRightButton()
        configView()
        refreshDataIfNeed()
    }
    
    private func configView() {
        weatherView = WeatherView()
        view.addSubview(weatherView)
        weatherView.mas_makeConstraints { make in
            make?.edges.offset()(0)
        }
        
        weatherView.selectCallback = { [weak self] index in
            guard let self = self,
                  let dailyModels = self.weatherModel?.daily,
                  index >= 0 && index < dailyModels.count else {
                return
            }
            let vc = DailyDetailViewController(model: dailyModels[index])
            self.navigationController?.present(vc, animated: true)
        }
    }
    
    /// if app has location permission, then request weather data
    private func refreshDataIfNeed() {
        guard requestIdle else { return }
        guard LocationManager.shared.checkPermission() else { return }
        requestIdle = false
        /// request location coordinate
        LocationManager.shared.requestLocation { [weak self] coordinate in
            guard let self = self else { return }
            guard let coordinate = coordinate else {
                self.requestIdle = true // closure in main thread
                return
            }
            /// request weather data
            self.dataManager.requestWeatherData(latitude: coordinate.latitude, longitude: coordinate.longitude) { [weak self] model, error in
                defer {
                    self?.requestIdle = true // closure in main thread
                }
                guard let self = self, error == nil, let model = model else { return }
                self.weatherModel = model
            }
        }
    }
}

extension ViewController {
    func configNavRightButton() {
        let rightButton: UIBarButtonItem
        if requestIdle {
            rightButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonClick))
        } else {
            let loadingView = UIActivityIndicatorView(style: .medium)
            loadingView.startAnimating()
            rightButton = UIBarButtonItem(customView: loadingView)
        }
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc private func refreshButtonClick() {
        /// request location authorization
        LocationManager.shared.requestPermissionIfNeed { [unowned self] hasPermission in
            guard hasPermission else { return }
            self.refreshDataIfNeed()
        }
    }
    
}


