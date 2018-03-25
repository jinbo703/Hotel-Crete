//
//  AboutCreteDetailCell.swift
//  HotelCrete
//
//  Created by John Nik on 24/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class AboutCreteDetailCell: SocialMediaCell {
    
    var detailController: AboutCreteDetailController?
    
    var creteDetail: Crete.CreteDetail? {
        
        didSet {
            
            guard let creteDetail = creteDetail else { return }
            
            let title = detailController?.getLocalizedString(from: creteDetail)?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            self.socialButton.setTitle(title, for: .normal)
            
        }
    }
    
    override func handleSocialButton() {
        guard let creteDetail = creteDetail else { return }
        detailController?.handleWhereToController(creteDetail: creteDetail)
    }
    
    override func setupViews() {
        super.setupViews()
        
    }
}
