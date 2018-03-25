//
//  Extension+String.swift
//  InstaChain
//
//  Created by John Nik on 2/1/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    var trailingNewLinesTrimmed: String {
        var newString = self
        
        while newString.hasSuffix("\n") {
            newString = String(newString.dropLast())
        }
        
        return newString
    }
    var trailingSpacesTrimmed: String {
        var newString = self
        
        while newString.hasSuffix(" ") {
            newString = String(newString.dropLast())
        }
        
        return newString
    }
    
    var trimingAllSpaces: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    var trimingAllSpacesAndNewLines: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

public extension String {
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf16) else { return NSAttributedString() }
        
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToAttributedStringForRussian: NSAttributedString? {
        guard let data = data(using: .utf16, allowLossyConversion: true) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToMutableAttributedString: NSMutableAttributedString? {
        
        guard let data = data(using: .utf8) else { return NSMutableAttributedString() }
        do {
            return try NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSMutableAttributedString()
        }
        
    }
    
    func htmlToAttributedString(for fontSize: Int) -> NSMutableAttributedString? {
        if let attributedString = htmlToMutableAttributedString {
            attributedString.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: CGFloat(fontSize))], range: NSRange(location: 0, length: attributedString.string.count))
            return attributedString
        } else {
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    var htmlToStringForRussian: String {
        return htmlToAttributedStringForRussian?.string ?? ""
    }
    
    var isEmptyStr: Bool{
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces).isEmpty
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    
    func doTrimming() -> String{
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func length() -> Int {
        return self.count
    }
    
    func stringFromHtml() -> NSAttributedString? {
        do {
            let data = self.data(using: String.Encoding.utf8, allowLossyConversion: true)
            if let d = data {
                let str = try NSAttributedString(data: d,
                                                 options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                                                 documentAttributes: nil)
                
                
                return str
            }
        } catch {
        }
        return nil
    }
    
    static func random(length: Int = 20) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}
