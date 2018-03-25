//
//  CreteExtraDetailCell.swift
//  HotelCrete
//
//  Created by John Nik on 24/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class CreteExtraDetailCell: HotelMenuCell {
    
    var creteExtraDetail: Crete.CreteExtraDetail? {
        
        didSet {
            guard let creteExtraDetail = creteExtraDetail else { return }
            self.setupCreteExtraDetail(creteExtraDetail)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
    }
    
    func setupCreteExtraDetail(_ detail: Crete.CreteExtraDetail) {
        if let imageUrl = detail.image, imageUrl.count > 0 {
            
            let imageUrls = imageUrl.components(separatedBy: ",")
            let urlString = imageUrls[0]
            
            self.backgroundImageView.loadSDWebImageWithUrlString(urlString)
        }
        
        var title: String?
        
        if currentLanguage() == DisplayName.england.rawValue {
            title = detail.title
        } else if currentLanguage() == DisplayName.france.rawValue {
            title = detail.title_french
        } else if currentLanguage() == DisplayName.germany.rawValue {
            title = detail.title_german
        } else if currentLanguage() == DisplayName.italy.rawValue {
            title = detail.title_italian
        } else {
            title = detail.title_russian
        }
        
        self.titleLabel.text = title
        textViewDidChange(titleLabel)
    }
    
}
