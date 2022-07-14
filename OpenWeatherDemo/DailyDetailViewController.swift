//
//  DailyDetailViewController.swift
//  OpenWeatherDemo
//
//  Created by 沈庾涛 on 2022/7/13.
//

import UIKit
import Masonry

class DailyDetailViewController: UIViewController {

    private var model: Daily
    private var detailText: UILabel!
    
    init(model: Daily) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        detailText = UILabel()
        view.addSubview(detailText);
        detailText.mas_makeConstraints { make in
            make?.edges.equalTo()(view)
        }
        detailText.text = model.detailText
        detailText.textAlignment = .center
    }
}
