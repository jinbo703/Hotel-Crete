//
//  Message.swift
//  HotelCrete
//
//  Created by John Nik on 26/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import Foundation

class Message {
    
    enum ResultChat {
        case success(ResponseChat)
        case failure(Error)
    }
    
    struct RequestChat: Codable {
        let chat: ChatInfo?
    }
    
    struct ResponseChat: Codable {
        let isSuccess: String?
        let data: [Chat]?
    }
    
    struct ChatInfo: Codable {
        let uid: String?
        let code: Int?
        let name: String?
        let msg: String?
        let image: String?
        let created_date: String?
    }
    
    struct Chat: Codable {
        let Chat: ChatInfo?
    }
    
}
