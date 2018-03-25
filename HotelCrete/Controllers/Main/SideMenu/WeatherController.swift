//
//  WheatherController.swift
//  HotelCrete
//
//  Created by John Nik on 27/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import SVProgressHUD

class WeatherController: UIViewController {
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    var weathers: [Weather.WeatherDetail] = []
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        fethcWeather()
    }
}

extension WeatherController {
    
    fileprivate func fethcWeather() {
        
        guard ReachabilityManager.shared.internetIsUp else {
            
            self.showPMAlertOkay(title: "Internet Error", message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        
        APIService.sharedInstance.handleWeatherAPI { (result: Weather.ResultWeather) in
            switch result {
            case .failure(_):
                self.showErrorMessage(title: "Server Error", message: AlertMessages.somethingWentWrong.rawValue)
            case .success(let response):
                if let weathers = response.list {
                    
                    self.setupWeather(weathers)
                }
            }
        }
        
    }
    
    func setupWeather(_ weathers: [Weather.WeatherDetail]) {
        
        let today = Date().yesterday
        var tomorrow = today.tomorrow
        
        for var weather in weathers {
            
            weather.day = tomorrow.dateString(withFormat: "EEEE")
            tomorrow = tomorrow.tomorrow
            
            self.weathers.append(weather)
        }
        
        
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

extension WeatherController {
    
    func showErrorMessage(title: String, message: String) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.showPMAlertOkay(title: title, message: message)
        }
    }
}

extension WeatherController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weathers.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WeatherCell
        
        cell.weather = weathers[indexPath.row + 1]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let weatherHeaderCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! WeatherHeaderCell
        
        if weathers.count > 0 {
            weatherHeaderCell.weather = weathers[0]
        }
        
        return weatherHeaderCell
    }
}

extension WeatherController {
    
    fileprivate func setupViews() {
        
        setupBackground()
        setupNavBar()
        setupTableView()
    }
    
    private func setupTableView() {
        
        tableView.register(WeatherCell.self, forCellReuseIdentifier: cellId)
        tableView.register(WeatherHeaderCell.self, forHeaderFooterViewReuseIdentifier: headerId)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    private func setupNavBar() {
        
        navigationItem.title = "Weather".localized()
    }
    
    private func setupBackground() {
        view.backgroundColor = .white
    }
}
