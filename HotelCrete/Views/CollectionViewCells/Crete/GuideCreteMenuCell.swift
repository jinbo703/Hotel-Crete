//
//  GuideCreteMenuCell.swift
//  HotelCrete
//
//  Created by John Nik on 24/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class GuideCreteMenuCell: HotelMenuCell {
    
    var guideCreteMenuController: GuideCreteMenuController?
    
    var guideCrete: Crete.GuideCrete? {
        
        didSet {
            guard let guideCrete = guideCrete else { return }
            
            self.setupGuideCrete(guideCrete)
        }
    }
    
    func setupGuideCrete(_ guideCrete: Crete.GuideCrete) {
        
        if let imageUrl = guideCrete.image {
            
            self.backgroundImageView.loadSDWebImageWithUrlString(imageUrl)
        }
        
        self.titleLabel.text = guideCreteMenuController?.getLocalizedString(from: guideCrete)
        
        textViewDidChange(titleLabel)
        
    }
    
    override func setupViews() {
        super.setupViews()
        
    }
}
