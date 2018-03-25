//
//  GuideCreteDataAreaListCell.swift
//  HotelCrete
//
//  Created by John Nik on 26/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class GuideCreteDataAreaListCell: CreteMenuCell {
    
    var guideCreteDataAreaListController: GuideCreteDataAreaListController?
    
    var guideDataDetail: Crete.GuideDataDetail? {
        
        didSet {
            guard let guideDataDetail = guideDataDetail else { return }
            
            self.setupGuideDataDetail(guideDataDetail)
        }
    }
    
    func setupGuideDataDetail(_ guideDataDetail: Crete.GuideDataDetail) {
        
        if let imageUrl = guideDataDetail.image {
            
            let imageUrls = imageUrl.components(separatedBy: ",")
            
            let urlString = imageUrls[0]
            
            self.backgroundImageView.loadSDWebImageWithUrlString(urlString)
        }
        self.titleLabel.text = guideCreteDataAreaListController?.getLocalizedString(from: guideDataDetail, type: .title)
        textViewDidChange(titleLabel)
    }
    
    override func setupViews() {
        super.setupViews()
        
    }
    
}
