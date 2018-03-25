//
//  GuideCreteListCell.swift
//  HotelCrete
//
//  Created by John Nik on 24/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class GuideCreteListCell: CreteMenuCell {
    
    var guideCreteListController: GuideCreteListController?
    
    var guideCreteList: Crete.GuideList? {
        
        didSet {
            guard let guideCreteList = guideCreteList else { return }
            
            self.setupGuideCreteList(guideCreteList)
        }
    }
    
    func setupGuideCreteList(_ guideCreteList: Crete.GuideList) {
        
        if let imageUrl = guideCreteList.image {
            
            let imageUrls = imageUrl.components(separatedBy: ",")
            
            let urlString = imageUrls[0]
            
            self.backgroundImageView.loadSDWebImageWithUrlString(urlString)
        }
        self.titleLabel.text = guideCreteListController?.getLocalizedString(from: guideCreteList)
        textViewDidChange(titleLabel)
    }
    
    override func setupViews() {
        super.setupViews()
        
    }
    
}
