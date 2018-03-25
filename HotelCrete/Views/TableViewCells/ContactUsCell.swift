//
//  ContactUsCell.swift
//  HotelCrete
//
//  Created by John Nik on 18/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class ContactUsCell: BaseTableViewCell {
    
    var contact: Contact? {
        
        didSet {
            guard let contact = contact else { return }
            
            if let title = contact.title {
                self.titleLabel.text = title
            }
            
            if let contactDetail = contact.contactDetail {
                self.contactLabel.text = contactDetail
            }
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Telephone Number"
        return label
    }()
    
    let contactLabel: UILabel = {
        let label = UILabel()
        label.text = "+34353453453"
        label.textColor = StyleGuideManager.mainLightBlueBackgroundColor
        return label
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 15, width: 0, height: 20)
        
        addSubview(contactLabel)
        contactLabel.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 15, paddingRight: 0, width: 0, height: 20)
        
        
    }
}
