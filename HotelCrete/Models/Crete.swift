//
//  Crete.swift
//  HotelCrete
//
//  Created by John Nik on 24/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import Foundation
import CoreLocation

class Crete {
    
    struct CreteExtraId: Codable {
        let id: Int
        let hotelid: Int
    }
    
    struct HotelId: Codable {
        let hotelid: Int
    }
    
    // get region villages
//    {"GuideVillage":{"region":"East Crete"}}
    
    enum ResultGuideVillage {
        case success(ResponseGuideVillage)
        case failure(Error)
    }
    
    struct ResponseGuideVillage: Codable {
        let status: Bool?
        let msg: String?
        let result: [GuideVillage]?
    }
    
    struct GuideVillage: Codable {
        let GuideVillage: GuideListDetail?
    }
    
    struct RequestGuideVillage: Codable {
        var GuideVillage: Region
    }
    
    struct Region: Codable {
        var region: String
    }
    
    //guide crete region
    
    enum ResultBeachRegion {
        case success(ResponseBeachRegion)
        case failure(Error)
    }
    
    struct ResponseBeachRegion: Codable {
        let status: Bool?
        let msg: String?
        let result: [BeachRegion]?
    }
    
    struct BeachRegion: Codable {
        let BeachRegion: BeachRegionInfo?
        let beaches: [GuideDataDetail]?
    }
    
    struct BeachRegionInfo: Codable {
        let id: String?
        let region: String?
        let region_greek: String?
        let regionimage: String?
        let created_date: String?
        
        let region_french: String?
        let region_german: String?
        let region_italian: String?
        let region_russian: String?
    }
    
    //guide crete
    
    enum ResultGuideCrete {
        case success(ResponseGuideCrete)
        case failure(Error)
    }
    
    struct ResponseGuideCrete: Codable {
        let status: Bool?
        let msg: String?
        let result: [GuideCreteInfo]?
    }
    
    struct GuideCreteInfo: Codable {
        let GuideCrete: GuideCrete?
        let GuideList: [GuideList]?
        let GuideData: [GuideData]?
    }
    
    struct GuideList: Codable {
        let id: String?
        let guidecreteid: String?
        let title: String?
        let description: String?
        let image: String?
        let latitude: String?
        let longitude: String?
        let created_date: String?
        let title_greek: String?
        
        let title_french: String?
        let description_french: String?
        let title_german: String?
        let description_german: String?
        let title_italian: String?
        let description_italian: String?
        let title_russian: String?
        let description_russian: String?
        
        let GuideCrete: GuideCrete?
        let GuideVillage: [GuideListDetail]?
        let GuideSightseeing: [GuideListDetail]?
    }
    
    struct GuideDataDetail: Codable {
        let id: String?
        let guidedataid: String?
        let region: String?
        let regionimage: String?
        let title: String?
        let created_date: String?
        let image: String?
        let description: String?
        let description_greek: String?
        let title_greek: String?
        let latitude: String?
        let longitude: String?
        
        let title_french: String?
        let description_french: String?
        let region_french: String?
        let title_german: String?
        let description_german: String?
        let region_german: String?
        let title_italian: String?
        let description_italian: String?
        let region_italian: String?
        let title_russian: String?
        let description_russian: String?
        let region_russian: String?
    }
    
    struct GuideData: Codable {
        let id: String?
        let guidecreteid: String?
        let title: String?
        let image: String?
        let latitude: String?
        let longitude: String?
        let description: String?
        let created_date: String?
        let title_greek: String?
        
        let title_french: String?
        let description_french: String?
        let title_german: String?
        let description_german: String?
        let title_italian: String?
        let description_italian: String?
        let title_russian: String?
        let description_russian: String?
        
        let GuideCrete: GuideCrete?
        let GuideBeache: [GuideDataDetail]?
        
    }
    
    struct GuideListDetail: Codable {
        let id: String?
        let region: String?
        let guidelistid: String?
        let title: String?
        let description: String?
        let latitude: String?
        let longitude: String?
        let image: String?
        let created_date: String?
        let title_greek: String?
        let description_greek: String?
        let region_greek: String?
        
        let title_french: String?
        let description_french: String?
        let region_french: String?
        let title_german: String?
        let description_german: String?
        let region_german: String?
        let title_italian: String?
        let description_italian: String?
        let region_italian: String?
        let title_russian: String?
        let description_russian: String?
        let region_russian: String?
    }
    
    
    
    struct GuideCrete: Codable {
        let id: String?
        let title: String?
        let image: String?
        let created_date: String?
        let title_greek: String?
        
        let title_french: String?
        let title_german: String?
        let title_italian: String?
        let title_russian: String?
    }
    
    //get aboutcrete
    
    enum ResultAboutCrete {
        case success(ResponseAboutCrete)
        case failure(Error)
    }
    
    struct ResponseAboutCrete: Codable {
        let status: Bool?
        let msg: String?
        let result: [AboutCreteInfo]?
    }
    
    struct AboutCreteInfo: Codable {
        let AboutCrete: AboutCrete?
        let CreteDetail: [CreteDetail]?
    }
    
    struct AboutCrete: Codable {
        let id: String?
        let title: String?
        let title_greek: String?
        let description: String?
        let description_greek: String?
        let image: String?
        let background: String?
        let created_date: String?
        
        let title_french: String?
        let description_french: String?
        let title_german: String?
        let description_german: String?
        let title_italian: String?
        let description_italian: String?
        let title_russian: String?
        let description_russian: String?
        
    }
    
    struct CreteDetail: Codable {
        let id: String?
        let creteid: String?
        let title: String?
        let title_greek: String?
        let description: String?
        let description_greek: String?
        let created_date: String?
        
        let title_french: String?
        let description_french: String?
        let title_german: String?
        let description_german: String?
        let title_italian: String?
        let description_italian: String?
        let title_russian: String?
        let description_russian: String?
        
        let Gastronomy: [Gastronomy]?
    }
    
    struct Gastronomy: Codable {
        let id: String?
        let cretedetailid: String?
        let title: String?
        let description: String?
        let image: String?
        let created_date: String?
        let title_greek: String?
        let description_greek: String?
        
        let title_french: String?
        let description_french: String?
        let title_german: String?
        let description_german: String?
        let title_italian: String?
        let description_italian: String?
        let title_russian: String?
        let description_russian: String?
    }
    
    //get crete extra detail
    
    struct RequestCreteExtraDetail: Codable {
        let GuideShopping: CreteExtraId
    }
    
    struct ResponseCreteExtraDetail: Codable {
        let status: Bool?
        let msg: String?
        let result: [GuideShopping]?
    }
    
    enum ResultCreteExtraDetail {
        case success(ResponseCreteExtraDetail)
        case failure(Error)
    }
    
    struct GuideShopping: Codable {
        let GuideShopping: CreteExtraDetail?
    }
    
    struct CreteExtraDetail: Codable {
        let id: String?
        let creteextraid: String?
        let title: String?
        let image: String?
        let description: String?
        let latitude: String?
        let longitude: String?
        let created_date: String?
        let title_greek: String?
        let description_greek: String?
        
        let title_french: String?
        let description_french: String?
        let title_german: String?
        let description_german: String?
        let title_italian: String?
        let description_italian: String?
        let title_russian: String?
        let description_russian: String?
        
        var latitudeDegree: CLLocationDegrees? {
            
            guard let latitude = latitude else { return nil }
            let latArr = latitude.components(separatedBy: ",")
            
            guard let lat = Double(latArr[0].trimingAllSpacesAndNewLines) else {
                return nil
            }
            return lat
        }
        var longitudeDegree: CLLocationDegrees? {
            guard let longitude = longitude else { return nil }
            let longArr = longitude.components(separatedBy: ",")
            
            guard let long = Double(longArr[0].trimingAllSpacesAndNewLines) else {
                return nil
            }
            return long
        }
        
        var location: CLLocation? {
            guard let latitude = latitudeDegree, let logitude = longitudeDegree else { return nil }
            return CLLocation(latitude: latitude, longitude: logitude)
        }
        
        func distance(to location: CLLocation) -> CLLocationDistance? {
            guard let hotelLocation = self.location else { return nil }
            let distance = location.distance(from: hotelLocation)
            return distance
        }
    }
    
    // get crete extra
    
    struct CreteExtraInfo: Codable {
        let id: String?
        let title: String?
        let image: String?
        let created_date: String?
        let title_greek: String?
        
        let title_french: String?
        let title_german: String?
        let title_italian: String?
        let title_russian: String?
    }
    
    struct CreteExtra: Codable {
        let CreteExtra: CreteExtraInfo?
    }
    
    struct ResponseCreteExtra: Codable {
        let status: Bool?
        let msg: String?
        let result: [CreteExtra]?
    }
    
    enum ResultCreteExtra {
        case success(ResponseCreteExtra)
        case failure(Error)
    }
    
}
