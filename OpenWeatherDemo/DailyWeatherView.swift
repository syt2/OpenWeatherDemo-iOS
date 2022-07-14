//
//  DailyWeatherView.swift
//  OpenWeatherDemo
//
//  Created by 沈庾涛 on 2022/7/12.
//

import UIKit
import Masonry
import SDWebImage


class DailyWeatherView: UIView {
    private var tableView: UITableView!
    private var emptyView: EmptyView!
    
    /// table view cell select callback
    var selectCallback: ((_ index: Int) -> Void)?
    
    /// daily weather models array
    var dailyModels: [Daily]? {
        didSet {
            reloadData()
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
        tableView = UITableView(frame: .zero)
        addSubview(tableView)
        tableView.mas_makeConstraints { make in
            make?.edges.equalTo()(self)
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DailyWeatherCell.self, forCellReuseIdentifier: DailyWeatherCell.cellIdentifier)
        tableView.rowHeight = 56
        tableView.tableFooterView = UIView()
        
        emptyView = EmptyView(frame: .zero)
        addSubview(emptyView)
        emptyView.mas_makeConstraints { make in
            make?.edges.equalTo()(self)
        }
        reloadData()
    }
    
    private func reloadData() {
        tableView.reloadData()
        let isModelInvaild = dailyModels?.isEmpty ?? true
        emptyView.isHidden = !isModelInvaild
        tableView.isHidden = isModelInvaild
    }
}

// MARK: UITableViewDataSource
extension DailyWeatherView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dailyModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DailyWeatherCell.cellIdentifier) as? DailyWeatherCell ?? DailyWeatherCell(style: .default, reuseIdentifier: DailyWeatherCell.cellIdentifier)
        if let dailyModel = dailyModels?[indexPath.row] {
            cell.updateCell(dailyModel)
        }
        return cell
    }
}

// MARK: UITableViewDelegate
extension DailyWeatherView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        selectCallback?(indexPath.row)
    }
}

private class EmptyView: UIView {
    private var emptyLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    private func configView() {
        emptyLabel = UILabel()
        addSubview(emptyLabel)
        emptyLabel.mas_makeConstraints { make in
            make?.center.equalTo()(self)
        }
        emptyLabel.textAlignment = .center
        emptyLabel.text = "Empty"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: table view cell implement
private class DailyWeatherCell: UITableViewCell {
    static let cellIdentifier = "daliyWeatherTableViewCell"
    
    private var iconImageView: UIImageView!
    private var dateLabel: UILabel!
    private var temperatureLabel: UILabel!
    
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
    }
    
    private func configView() {
        iconImageView = UIImageView()
        addSubview(iconImageView)
        iconImageView.mas_makeConstraints { make in
            make?.width.height()?.equalTo()(48)
            make?.left.offset()(8)
            make?.centerY.offset()(0)
        }
        
        dateLabel = UILabel()
        addSubview(dateLabel)
        dateLabel.mas_makeConstraints { make in
            make?.left.mas_equalTo()(iconImageView.mas_right)?.offset()(16)
            make?.top.mas_equalTo()(iconImageView)
        }
        dateLabel.font = UIFont.systemFont(ofSize: 18)
        dateLabel.textColor = .darkGray
        
        temperatureLabel = UILabel()
        addSubview(temperatureLabel)
        temperatureLabel.mas_makeConstraints { make in
            make?.left.mas_equalTo()(dateLabel)
            make?.bottom.mas_equalTo()(iconImageView)
        }
        temperatureLabel.font = UIFont.systemFont(ofSize: 16)
        temperatureLabel.textColor = .gray
    }
}

