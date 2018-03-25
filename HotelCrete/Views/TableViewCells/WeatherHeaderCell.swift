//
//  WheatherHeaderCell.swift
//  HotelCrete
//
//  Created by John Nik on 27/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class WeatherHeaderCell: UITableViewHeaderFooterView {
    
    var weather: Weather.WeatherDetail? {
        
        didSet {
            
            guard let weather = weather else { return }
            
            self.setupWeather(weather)
        }
        
    }
    
    let backgroundImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
        
    }()
    
    let dayLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 25)
        label.textAlignment = .center
        return label
    }()
    
    let tempLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
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
    
    let dateLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    let weatherLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
        
    }()
    
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension WeatherHeaderCell {
    
    func setupWeather(_ weather: Weather.WeatherDetail) {
        
        let image = UIImage(named: "weatherBackground.jpg")
        backgroundImageView.image = image
        
        dayLabel.text = "Today".localized()
        
        if let tempFloat = weather.temp?.day {
            let temp = String(Int(tempFloat))
            tempLabel.text = temp + "\u{00B0}C"
        }
        
        if let weathers = weather.weather, weathers.count > 0, let iconId = weathers[0].icon {
            let iconUrl = String(format: ServerUrls.weatherIconUrl, iconId)
            
            self.iconImageView.loadSDWebImageWithUrlString(iconUrl)
            self.weatherLabel.text = weathers[0].main?.localized()
        }
        
        self.dateLabel.text = Date().dateString(withFormat: "dd/MM/yyyy")
    }
}


extension WeatherHeaderCell {
    
    fileprivate func setupViews() {
        
        backgroundColor = .white
        contentView.backgroundColor = .white
        
        setupImageView()
        setupWeatherView()
    }
    
    fileprivate func setupWeatherView() {
        
        addSubview(dayLabel)
        dayLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        addSubview(tempLabel)
        tempLabel.anchor(top: dayLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: centerXAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: centerXAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 30, paddingRight: 0, width: 0, height: 40)
        
        addSubview(weatherLabel)
        weatherLabel.anchor(top: nil, left: centerXAnchor, bottom: dateLabel.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: 0, height: 40)
        
        addSubview(iconImageView)
        iconImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        iconImageView.centerXAnchor.constraint(equalTo: weatherLabel.centerXAnchor).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: tempLabel.centerYAnchor).isActive = true
        
        let toplinView = UIView()
        toplinView.backgroundColor = .white
        
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = .white
        
        addSubview(toplinView)
        toplinView.anchor(top: nil, left: leftAnchor, bottom: dateLabel.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: 1)
        
        addSubview(bottomLineView)
        bottomLineView.anchor(top: dateLabel.bottomAnchor, left: toplinView.leftAnchor, bottom: nil, right: toplinView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
    }
    
    fileprivate func setupImageView() {
        
        addSubview(backgroundImageView)
        backgroundImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 0)
    }
}
