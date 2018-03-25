//
//  ServiceCell.swift
//  HotelCrete
//
//  Created by John Nik on 18/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class ServiceCell: BaseTableViewCell {
    
    var detail: String? {
        
        didSet {
            guard let detail = detail else { return }
            detailTextView.attributedText = detail.htmlToAttributedString
        }
        
    }
    
    let detailTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textAlignment = .center
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textColor = .white
        textView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        return textView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .clear
        alpha = 0.8
        
        addSubview(detailTextView)
        detailTextView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
    }
}
