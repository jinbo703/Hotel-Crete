//
//  GeneralInfo.swift
//  HotelCrete
//
//  Created by John Nik on 28/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import Foundation


class UsefulInfo {
    
    enum ResultUsefulInfo {
        case success(ResponseUsefulInfo)
        case failure(Error)
    }
    
    struct ResponseUsefulInfo: Codable {
        let status: Bool?
        let msg: String?
        let result: [GroupedUsefulInfo]?
    }
    
    struct GroupedUsefulInfo: Codable {
        let UsefulInfo: UsefulInfoDetail
    }
    
    struct UsefulInfoDetail: Codable {
        
        let id: String
        let title: String?
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
    }
    
    struct ExpandedUsefulInfo {
        
        var isExpanded: Bool
        var title: String?
        var description: [String?]?
    }
    
}
