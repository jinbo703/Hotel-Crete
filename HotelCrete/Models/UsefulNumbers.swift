//
//  UsefulNumbers.swift
//  HotelCrete
//
//  Created by John Nik on 28/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import Foundation

class UsefulNumbers {
    
    enum ResultUsefulNumbers {
        case success(ResponseUsefulNumbers)
        case failure(Error)
    }
    
    struct ResponseUsefulNumbers: Codable {
        let status: Bool?
        let msg: String?
        let result: [UsefulNumbers]?
    }
    
    struct UsefulNumbers: Codable {
        let UsefulNumber: UsefulNumber?
        let UsefulData: [UsefulNumberDetail]?
    }
    
    struct UsefulNumberDetail: Codable {
        let id: String?
        let usefulnumberid: String?
        let title: String?
        let number: String?
        let created_date: String?
        
        let title_french: String?
        let title_german: String?
        let title_italian: String?
        let title_russian: String?
    }
    
    struct UsefulNumber: Codable {
        let id: String?
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
    }
    
}
