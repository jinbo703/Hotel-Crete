//
//  GuideCreteDataCell.swift
//  HotelCrete
//
//  Created by John Nik on 25/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class GuideCreteDataCell: SocialMediaCell {
    
    var guideCreteDataController: GuideCreteDataController?
    
    var guideCreteData: Crete.GuideData? {
        
        didSet {
            guard let guideCreteData = guideCreteData else { return }
            
            let title = guideCreteDataController?.getLocalizedString(from: guideCreteData)
            
            self.socialButton.setTitle(title, for: .normal)
        }
        
    }
    
    
    override func handleSocialButton() {
        
        guard let guidCreteData = guideCreteData else { return }
        guideCreteDataController?.didSelectGuideCreteData(guidCreteData)
    }
    
}
