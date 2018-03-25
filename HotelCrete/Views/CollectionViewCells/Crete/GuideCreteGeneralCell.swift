//
//  GuideCreteGeneralCell.swift
//  HotelCrete
//
//  Created by John Nik on 21/03/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class GuideCreteGeneralCell: HotelMenuCell {
    
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        backgroundImageView.contentMode = .scaleAspectFit
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
    }
    
    override func layoutSubviews() {
        
    }
}
