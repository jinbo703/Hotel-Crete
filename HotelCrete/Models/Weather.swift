//
//  Weather.swift
//  HotelCrete
//
//  Created by John Nik on 27/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import Foundation

class Weather {
    
    enum ResultWeather {
        case success(ResponseWeather)
        case failure(Error)
    }
    
    struct ResponseWeather: Codable {
        let city: City?
        let cod: String?
        let message: Float?
        let cnt: Int?
        var list: [WeatherDetail]?
    }
    
    struct City: Codable {
        let id: Int?
        let name: String?
        let coord: Coordinate?
        let country: String?
        let population: Int?
    }
    
    struct Coordinate: Codable {
        let lan: Float?
        let lat: Float?
    }
    
    struct WeatherDetail: Codable {
        let dt: Int?
        let temp: Temperature?
        let pressure: Float?
        let humidity: Float?
        let weather: [Weather]?
        let speed: Float?
        let deg: Int?
        let clouds: Int?
        let rain: Float?
        var day: String?
    }
    
    struct Weather: Codable {
        let id: Int?
        let main: String?
        let description: String?
        let icon: String?
    }
    
    struct Temperature: Codable {
        let day: Float?
        let min: Float?
        let max: Float?
        let night: Float?
        let eve: Float?
        let morn: Float?
    }
}
