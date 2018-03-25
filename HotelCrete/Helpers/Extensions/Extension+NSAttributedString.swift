//
//  Extension+NSAttributedString.swift
//  HotelCrete
//
//  Created by John Nik on 21/03/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import Foundation

extension NSAttributedString {
    
    var trailingNewlineChopped: NSAttributedString {
        if self.string.hasSuffix("\n") {
            return self.attributedSubstring(from: NSMakeRange(0, self.length - 1))
        } else {
            return self
        }
    }
    
}
