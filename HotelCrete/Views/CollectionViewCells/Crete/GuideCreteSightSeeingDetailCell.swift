//
//  GuideCreteSightSeeingDetailCell.swift
//  HotelCrete
//
//  Created by John Nik on 26/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class GuideCreteSightSeeingDetailCell: CreteMenuCell {
    
    var guideCreteSightSeeingDetailController: GuideCreteSightSeeingDetailController?
    
    var guideListDetail: Crete.GuideListDetail? {
        
        didSet {
            guard let guideListDetail = guideListDetail else { return }
            
            self.setupGuideCreteListDetail(guideListDetail)
        }
    }
    
    func setupGuideCreteListDetail(_ guideListDetail: Crete.GuideListDetail) {
        
        if let imageUrl = guideListDetail.image {
            
            let imageUrls = imageUrl.components(separatedBy: ",")
            let urlString = imageUrls[0]
            
            self.backgroundImageView.loadSDWebImageWithUrlString(urlString)
        }
        self.titleLabel.text = guideCreteSightSeeingDetailController?.getLocalizedString(from: guideListDetail)
        textViewDidChange(titleLabel)
    }
    
    override func setupViews() {
        super.setupViews()
        
    }
    
}
