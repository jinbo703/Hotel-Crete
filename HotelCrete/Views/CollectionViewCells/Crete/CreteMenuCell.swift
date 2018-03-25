//
//  CreteMenuCell.swift
//  HotelCrete
//
//  Created by John Nik on 24/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class CreteMenuCell: HotelMenuCell {
    
    var creteExtraInfo: Crete.CreteExtraInfo? {
        
        didSet {
            guard let creteExtraInfo = creteExtraInfo else { return }
            self.setupCreteExtraInfo(creteExtraInfo)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
    }
    
    func setupCreteExtraInfo(_ creteExtraInfo: Crete.CreteExtraInfo) {
        
        if let imageUrl = creteExtraInfo.image {
            
            if GlobalFunction.isContainedString("http", of: imageUrl) {
                if let url = GlobalFunction.getUrlFromString(imageUrl) {
                    self.backgroundImageView.sd_setIndicatorStyle(.gray)
                    self.backgroundImageView.sd_addActivityIndicator()
                    self.backgroundImageView.sd_setImage(with: url, completed: nil)
                } else {
                    self.backgroundImageView.image = UIImage(named: imageUrl)
                }
                
            } else {
                self.backgroundImageView.image = UIImage(named: imageUrl)
            }
        }
        
        if let title = creteExtraInfo.title {
            self.titleLabel.text = title
            textViewDidChange(titleLabel)
        }
        
    }
}
