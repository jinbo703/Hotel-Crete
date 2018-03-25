//
//  MapDataProvider.swift
//  HotelCrete
//
//  Created by John Nik on 01/03/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import Foundation
import CoreLocation
class MapDataProvider: NSObject {
    
    static let sharedInstance = MapDataProvider()
    
    func fetchPindataWith(menuItem: HotelMap.MenuItem, completion: @escaping (([HotelMap.HotelPlace]) -> ())) -> () {
        
        guard let id = Int(menuItem.id) else { return }
        let guide = HotelMap.Guide(id: id, title: menuItem.title)
        let request = HotelMap.RequestGuide(Guide: guide)
        
        APIService.sharedInstance.handleGetPinData(request) { (result: HotelMap.ResultPinData) in
            
            switch result {
            case .failure(_):
                return
            case .success(let response):
                if let pindata = response.result {
                    
                    var hotelPlaces: [HotelMap.HotelPlace] = []
                    
                    for pin in pindata {
                        
                        let latArr = pin.lat.components(separatedBy: ",")
                        
                        if let id = Int(pin.id), let lat = Double(latArr[0].trimingAllSpaces), let long = Double(pin.long.trimingAllSpaces) {
                            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
                            let hotelPlace = HotelMap.HotelPlace(id: id, region: pin.region, region_greek: pin.region_greek, coordinate: coordinate)
                            
                            hotelPlaces.append(hotelPlace)
                        }
                    }
                    completion(hotelPlaces)
                }
            }
            
        }
        
    }
    
}
