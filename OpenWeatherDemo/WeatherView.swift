//
//  WeatherView.swift
//  OpenWeatherDemo
//
//  Created by 沈庾涛 on 2022/7/14.
//

import UIKit
import SDWebImage
import Masonry

class WeatherView: UIView {
    private var currentWeatherView: CurrentWeatherView!
    private var dailyWeatherTableView: UITableView!
    private var emptyView: EmptyView!
    
    /// table view cell select callback
    var selectCallback: ((_ index: Int) -> Void)?
    
    /// weather model
    var model: OpenWeatherModel? {
        didSet {
            refreshModel()
        }
    }
    
    init() {
        super.init(frame: .zero)
        configViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configViews() {
        currentWeatherView = CurrentWeatherView()
        addSubview(currentWeatherView)
        currentWeatherView.mas_makeConstraints { make in
            make?.left.right()?.top()?.mas_equalTo()(self)
            make?.height.equalTo()(108)
        }
        
        let lineView = UIView()
        currentWeatherView.addSubview(lineView)
        lineView.mas_makeConstraints { make in
            make?.height.equalTo()(1 / UIScreen.main.scale)
            make?.left.right()?.bottom()?.offset()(0)
        }
        lineView.backgroundColor = .gray
        
        dailyWeatherTableView = UITableView()
        addSubview(dailyWeatherTableView)
        dailyWeatherTableView.mas_makeConstraints { make in
            make?.top.equalTo()(currentWeatherView.mas_bottom)
            make?.left.right()?.bottom()?.mas_equalTo()(self)
        }
        dailyWeatherTableView.dataSource = self
        dailyWeatherTableView.delegate = self
        dailyWeatherTableView.register(DailyWeatherCell.self, forCellReuseIdentifier: DailyWeatherCell.cellIdentifier)
        dailyWeatherTableView.tableFooterView = UIView()
        
        emptyView = EmptyView()
        addSubview(emptyView)
        emptyView.mas_makeConstraints { make in
            make?.edges.equalTo()(self)
        }
        refreshModel()
    }
    
    private func refreshModel() {
        let isModelVaild = model != nil
        currentWeatherView.updateView(model?.current)
        dailyWeatherTableView.reloadData()
        emptyView.isHidden = isModelVaild
        dailyWeatherTableView.isHidden = !isModelVaild
        currentWeatherView.isHidden = !isModelVaild
    }
}

// MARK: UITableViewDataSource
extension WeatherView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model?.daily.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DailyWeatherCell.cellIdentifier) as? DailyWeatherCell ?? DailyWeatherCell(style: .default, reuseIdentifier: DailyWeatherCell.cellIdentifier)
        if let dailyModel = model?.daily[indexPath.row] {
            cell.updateCell(dailyModel)
        }
        return cell
    }
}

// MARK: UITableViewDelegate
extension WeatherView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        selectCallback?(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let dailyModel = model?.daily[indexPath.row] {
            return DailyWeatherCell.heightForCell(dailyModel)
        }
        return 0
    }
}


// MARK: current weather view implement
private class CurrentWeatherView: UIView {
    private var iconImageView: UIImageView!
    private var dateLabel: UILabel!
    private var temperatureLabel: UILabel!
    private var describeLabel: UILabel!
    
    init() {
        super.init(frame: .zero)
        configViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView(_ model: Current?) {
        let placeholderImage = UIImage(named: "placeholder")
        iconImageView.sd_setImage(with: model?.weather?.iconUrl, placeholderImage: placeholderImage, options: .retryFailed, context: nil)
        dateLabel.text = model?.dateText
        temperatureLabel.text = model?.temperatureText
        describeLabel.text = model?.detailText
    }
    
    private func configViews() {
        iconImageView = UIImageView()
        addSubview(iconImageView)
        iconImageView.mas_makeConstraints { make in
            make?.width.height()?.equalTo()(60)
            make?.left.offset()(16)
            make?.top.offset()(8)
        }
        
        dateLabel = UILabel()
        addSubview(dateLabel)
        dateLabel.mas_makeConstraints { make in
            make?.left.mas_equalTo()(iconImageView.mas_right)?.offset()(16)
            make?.top.mas_equalTo()(iconImageView)
        }
        dateLabel.font = UIFont.systemFont(ofSize: 20)
        dateLabel.textColor = .darkGray

        temperatureLabel = UILabel()
        addSubview(temperatureLabel)
        temperatureLabel.mas_makeConstraints { make in
            make?.left.mas_equalTo()(dateLabel)
            make?.bottom.mas_equalTo()(iconImageView)
        }
        temperatureLabel.font = UIFont.systemFont(ofSize: 18)
        temperatureLabel.textColor = .gray
        
        describeLabel = UILabel()
        addSubview(describeLabel)
        describeLabel.mas_makeConstraints { make in
            make?.left.mas_equalTo()(iconImageView)
            make?.top.mas_equalTo()(iconImageView.mas_bottom)?.offset()(8)
        }
        describeLabel.font = UIFont.systemFont(ofSize: 20)
        describeLabel.textColor = .darkGray
    }
}


// MARK: empty view implement
private class EmptyView: UIView {
    private var emptyLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configView() {
        emptyLabel = UILabel()
        addSubview(emptyLabel)
        emptyLabel.mas_makeConstraints { make in
            make?.center.equalTo()(self)
        }
        emptyLabel.textAlignment = .center
        emptyLabel.text = "Empty"
        emptyLabel.textColor = .darkGray
        emptyLabel.font = UIFont.systemFont(ofSize: 24)
    }
}

// MARK: table view cell implement
private class DailyWeatherCell: UITableViewCell {
    static let cellIdentifier = "daliyWeatherTableViewCell"
    
    private var iconImageView: UIImageView!
    private var dateLabel: UILabel!
    private var temperatureLabel: UILabel!
    private var precipitationLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// update cell with a daily model
    /// - Parameter dailyModel: daily model
    func updateCell(_ dailyModel: Daily) {
        let placeholderImage = UIImage(named: "placeholder")
        iconImageView.sd_setImage(with: dailyModel.weather?.iconUrl, placeholderImage: placeholderImage, options: .retryFailed, context: nil)
        dateLabel.text = dailyModel.dateText
        temperatureLabel.text = dailyModel.temperatureText
        if let precipitationText = dailyModel.precipitationText {
            precipitationLabel.isHidden = false
            precipitationLabel.text = precipitationText
        } else {
            precipitationLabel.isHidden = true
        }
    }
    
    private func configView() {
        iconImageView = UIImageView()
        addSubview(iconImageView)
        iconImageView.mas_makeConstraints { make in
            make?.width.height()?.equalTo()(48)
            make?.left.offset()(8)
            make?.centerY.offset()(0)
        }
        
        let labelContainerView = UIView()
        addSubview(labelContainerView)
        labelContainerView.mas_makeConstraints { make in
            make?.left.mas_equalTo()(iconImageView.mas_right)?.offset()(16)
            make?.top.bottom()?.right()?.offset()(0)
        }
        
        dateLabel = UILabel()
        labelContainerView.addSubview(dateLabel)
        dateLabel.mas_makeConstraints { make in
            make?.left.offset()(0)
            make?.top.offset()(8)
        }
        dateLabel.font = UIFont.systemFont(ofSize: 18)
        dateLabel.textColor = .darkGray
        
        temperatureLabel = UILabel()
        labelContainerView.addSubview(temperatureLabel)
        temperatureLabel.mas_makeConstraints { make in
            make?.left.offset()(0)
            make?.top.mas_equalTo()(dateLabel.mas_bottom)?.offset()(4)
        }
        temperatureLabel.font = UIFont.systemFont(ofSize: 16)
        temperatureLabel.textColor = .gray
        
        precipitationLabel = UILabel()
        labelContainerView.addSubview(precipitationLabel)
        precipitationLabel.mas_makeConstraints { make in
            make?.left.offset()(0)
            make?.top.mas_equalTo()(temperatureLabel.mas_bottom)?.offset()(4)
        }
        precipitationLabel.font = UIFont.systemFont(ofSize: 16)
        precipitationLabel.textColor = .gray
    }
    
    
    static func heightForCell(_ model: Daily) -> CGFloat {
        return model.rain == nil ? 56 : 56 + 24
    }
}
