//
//  GreekWordHeader.swift
//  HotelCrete
//
//  Created by John Nik on 27/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class GreekWordHeaderCell: UITableViewHeaderFooterView {
    
    
    var greekWordAbout: GreekWord.GreekWordAbout? {
        
        didSet {
            guard let greekWordAbout = greekWordAbout else { return }
            
            titleLabel.text = greekWordAbout.title
            descriptionTextView.text = greekWordAbout.description
        }
    }
    
    let titleLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .left
        return label
        
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = .darkGray
        textView.isUserInteractionEnabled = false
        textView.layer.cornerRadius = 5
        textView.layer.masksToBounds = true
        return textView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupViews()
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 30)
        
        addSubview(descriptionTextView)
        descriptionTextView.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: bottomAnchor, right: titleLabel.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GreekWordHeaderCell {
    
    fileprivate func setupViews() {
        
        contentView.backgroundColor = .white
    }
}
