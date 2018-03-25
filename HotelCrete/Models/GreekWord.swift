//
//  GreekWord.swift
//  HotelCrete
//
//  Created by John Nik on 27/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import Foundation


class GreekWord {
    
    struct GreekWordAbout {
        let title: String?
        let description: String?
    }
    
    enum ResultGreekWord {
        case success(ResponseGreekWord)
        case failure(Error)
    }
    
    struct ResponseGreekWord: Codable {
        let status: Bool?
        let msg: String?
        let result: [GreekWordList]?
    }
    
    struct GreekWordList: Codable {
        let GreekWord: GreekWord
        let GreekDescription: [GreekDescription]
    }
    
    struct GreekWord: Codable {
        let id: String
        let title: String
        let created_date: String?
    }
    
    struct GreekDescription: Codable {
        let id: String
        let greekwordsid: String
        let english: String
        let pronunciation: String
        let greek: String
        let created_date: String?
    }
    
}
