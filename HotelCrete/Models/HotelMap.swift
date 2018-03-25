//
//  HotelMap.swift
//  HotelCrete
//
//  Created by John Nik on 01/03/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces


class HotelMarker: GMSMarker {
    
    var place: HotelMap.HotelPlace
    
    init(place: HotelMap.HotelPlace) {
        self.place = place
        super.init()
        
        position = place.coordinate
        
        icon = UIImage(named: AssetName.redMapMarker.rawValue)
        appearAnimation = .pop
    }
}

class HotelMap {
    
    
    enum MenuTitle: String {
        case cities = "Cities"
        case townsVillages = "Towns/Villages"
        case beaches = "Beaches"
        case landscapes = "Landscapes"
        case archaelogoical = "Archaeological Sites/Ancient Cities"
        case museums = "Museums"
        case monuments = "Monuments/Sightseeings"
        case monasteries = "Monasteries/Churches"
    }
    
    // pin
    struct HotelPlace {
        let id: Int
        let region: String?
        let region_greek: String?
        let coordinate: CLLocationCoordinate2D
    }
    
    enum ResultPinData {
        case success(ResponsePinData)
        case failure(Error)
    }
    
    struct ResponsePinData: Codable {
        let status: Bool?
        let msg: String?
        let result: [PinData]?
    }
    
    struct PinData: Codable {
        let id: String
        let region: String?
        let region_greek: String?
        let lat: String
        let long: String
    }
    
    struct RequestGuide: Codable {
        let Guide: Guide
    }
    
    struct Guide: Codable {
        let id: Int
        let title: String
    }
    
    // get guide crete for menu  bar
    enum ResultGuideCrete {
        case success(ResponseGuideCrete)
        case failure(Error)
    }
    
    struct ResponseGuideCrete: Codable {
        let status: Bool?
        let msg: String?
        let result: [GuideCrete]?
    }
    
    struct GuideCrete: Codable {
        let GuideCrete: MenuItem
    }
    
    struct MenuItem: Codable {
        let id: String
        let title: String
        let image: String?
        let title_greek: String?
        let created_date: String?
        
        let title_french: String?
        let title_german: String?
        let title_italian: String?
        let title_russian: String?
    }
    
}
