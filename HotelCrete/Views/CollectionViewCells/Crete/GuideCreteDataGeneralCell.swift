//
//  GuideCreteDataGeneralCell.swift
//  HotelCrete
//
//  Created by John Nik on 25/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
class GuideCreteDataGeneralCell: CreteMenuCell {
    
    var guideCreteDataGeneralController: GuideCreteDataGeneralController?
    
    var guideCreteData: Crete.GuideData? {
        
        didSet {
            guard let guideCreteData = guideCreteData else { return }
            
            self.setupGuideCreteData(guideCreteData)
        }
    }
    
    func setupGuideCreteData(_ guideCreteData: Crete.GuideData) {
        
        if let imageUrl = guideCreteData.image {
            
            let imageUrls = imageUrl.components(separatedBy: ",")
            
            let urlString = imageUrls[0]
            
            self.backgroundImageView.loadSDWebImageWithUrlString(urlString)
        }
        self.titleLabel.text = guideCreteDataGeneralController?.getLocalizedString(from: guideCreteData, type: .title)
        textViewDidChange(titleLabel)
    }
    
    override func setupViews() {
        super.setupViews()
        
    }
    
}
