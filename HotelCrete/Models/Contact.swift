//
//  Contact.swift
//  HotelCrete
//
//  Created by John Nik on 18/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import Foundation

struct Contact {
    
    let title: String?
    let contactDetail: String?
    let type: ContactType?
}

enum ContactType {
    case telephone
    case fax
    case email
    case website
}
