//
//  AboutCreteGastronomyCell.swift
//  HotelCrete
//
//  Created by John Nik on 24/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class AboutCreteGastronomyCell: HotelMenuCell {
    
    var gastronomy: Crete.Gastronomy? {
        
        didSet {
            guard let gastronomy = self.gastronomy else {
                return
            }
            
            setupGastronomy(gastronomy)
        }
    }
    
    func setupGastronomy(_ gastronomy: Crete.Gastronomy) {
        if let imageUrl = gastronomy.image {
            
            self.backgroundImageView.loadSDWebImageWithUrlString(imageUrl)
        }
        self.titleLabel.text = getLocalizedString(from: gastronomy)
        textViewDidChange(titleLabel)
    }
    
    override func setupViews() {
        super.setupViews()
    }
}

extension AboutCreteGastronomyCell {
    
    func getLocalizedString(from detail: Crete.Gastronomy) -> String? {
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
