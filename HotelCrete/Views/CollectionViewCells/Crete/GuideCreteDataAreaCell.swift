//
//  GuideCreteDataAreaCell.swift
//  HotelCrete
//
//  Created by John Nik on 26/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class GuideCreteDataAreaCell: CreteMenuCell {
    
    var guideCreteDataAreaController: GuideCreteDataAreaController?
    
    var beachRegion: Crete.BeachRegion? {
        
        didSet {
            guard let beachRegion = beachRegion else { return }
            
            self.setupBeachRegion(beachRegion)
        }
    }
    
    func setupBeachRegion(_ beachRegion: Crete.BeachRegion) {
        
        if let imageUrl = beachRegion.BeachRegion?.regionimage {
            
            self.backgroundImageView.loadSDWebImageWithUrlString(imageUrl)
        }
        self.titleLabel.text = guideCreteDataAreaController?.getLocalizedString(from: beachRegion.BeachRegion)
        titleLabel.textColor = .black
        textViewDidChange(titleLabel)
    }
    
    override func setupViews() {
        super.setupViews()
        
    }
    
    override func layoutSubviews() {
        
    }
    
}
