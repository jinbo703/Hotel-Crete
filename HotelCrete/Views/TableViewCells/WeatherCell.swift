//
//  WheatherCell.swift
//  HotelCrete
//
//  Created by John Nik on 27/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import SDWebImage

class WeatherCell: BaseTableViewCell {
    
    var weather: Weather.WeatherDetail? {
        
        didSet {
            
            guard let weather = weather else { return }
            
            self.setupWeather(weather)
            
        }
        
    }
    
    let backgroundImageView: UIImageView = {
        
        let imageView = UIImageView()
        let image = UIImage(named: "weatherBackground.jpg")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let dayLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Thursday"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    let tempLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.text = "15\u{00B0}C"
        label.textColor = .white
        label.textAlignment = .center
        return label
        
    }()
    
    let iconImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        setupImageView()
        setupWeatherView()
    }
    
}

extension WeatherCell {
    
    func setupWeather(_ weather: Weather.WeatherDetail) {
        
        dayLabel.text = weather.day?.localized()
        
        if let tempFloat = weather.temp?.day {
            let temp = String(Int(tempFloat))
            tempLabel.text = temp + "\u{00B0}C"
        }
        
        if let weathers = weather.weather, weathers.count > 0, let iconId = weathers[0].icon {
            let iconUrl = String(format: ServerUrls.weatherIconUrl, iconId)
            
            self.iconImageView.loadSDWebImageWithUrlString(iconUrl)
        }
    }
    
}

extension WeatherCell {
    
    fileprivate func setupWeatherView() {
        
        addSubview(tempLabel)
        tempLabel.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 30)
        tempLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 30).isActive = true
        tempLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(dayLabel)
        dayLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: tempLabel.leftAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        dayLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(iconImageView)
        iconImageView.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 50, width: 40, height: 40)
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    fileprivate func setupImageView() {
        
        addSubview(backgroundImageView)
        backgroundImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 5, paddingRight: 10, width: 0, height: 0)
    }
}

