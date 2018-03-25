//
//  FacilitieDetailCell.swift
//  HotelCrete
//
//  Created by John Nik on 24/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class FacilitieDetailCell: DescriptionCell {
    
    var detail: HotelMenu? {
        
        didSet {
            guard let detail = detail else { return }
            self.setupDetail(detail)
        }
    }
    
    let detailTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textAlignment = .center
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.backgroundColor = .clear
        return textView
    }()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
    }
    
    func setupDetail(_ detail: HotelMenu) {
        self.titleLabel.text = detail.title
        
        if let imageUrl = detail.backgroundImageUrl {
            
            if GlobalFunction.isContainedString("http", of: imageUrl) {
                if let url = GlobalFunction.getUrlFromString(imageUrl) {
                    self.descriptionImageView.sd_setIndicatorStyle(.gray)
                    self.descriptionImageView.sd_addActivityIndicator()
                    self.descriptionImageView.sd_setImage(with: url, completed: nil)
                } else {
                    self.descriptionImageView.image = UIImage(named: imageUrl)
                }
                
            } else {
                self.descriptionImageView.image = UIImage(named: imageUrl)
            }
        }
        
        self.descriptionTextView.attributedText = detail.description?.htmlToAttributedString(for: 16)
    }
    
    

}
