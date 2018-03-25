//
//  AboutCreteMenuCell.swift
//  HotelCrete
//
//  Created by John Nik on 24/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class AboutCreteMenuCell: HotelMenuCell{
    
    
    var aboutCrete: Crete.AboutCrete? {
        
        didSet {
            guard let aboutCrete = aboutCrete else { return }
            
            self.setupAboutCrete(aboutCrete)
        }
    }
    
    func setupAboutCrete(_ aboutCrete: Crete.AboutCrete) {
        
        if let imageUrl = aboutCrete.image {
            
            self.backgroundImageView.loadSDWebImageWithUrlString(imageUrl)
        }
        
        self.titleLabel.text = getLocalizedString(from: aboutCrete)
        textViewDidChange(titleLabel)
        
    }
    
    override func setupViews() {
        super.setupViews()
        
    }
}

extension AboutCreteMenuCell {
    func getLocalizedString(from detail: Crete.AboutCrete) -> String? {
        var string: String?
        
        if currentLanguage() == DisplayName.england.rawValue {
            string = detail.title
        } else if currentLanguage() == DisplayName.france.rawValue {
            string = detail.title_french
        } else if currentLanguage() == DisplayName.germany.rawValue {
            string = detail.title_german
        } else if currentLanguage() == DisplayName.italy.rawValue {
            string = detail.title_italian
        } else {
            string = detail.title_russian
        }
        
        return string
    }
}
