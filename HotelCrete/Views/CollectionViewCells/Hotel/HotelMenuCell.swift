//
//  HotelMenuCell.swift
//  HotelCrete
//
//  Created by John Nik on 18/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit


class HotelMenuCell: BaseCollectionViewCell {
    
    var hotelMenu: HotelMenu? {
        
        didSet {
            guard let hotelMenu = hotelMenu else { return }
            
            self.setupHotelMenu(hotelMenu)
        }
    }
    
    let backgroundImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        
        
        return imageView
    }()
    
    lazy var titleLabel: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.textColor = .white
        textView.isEditable = false
        textView.isSelectable = false
        textView.isUserInteractionEnabled = false
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 10, bottom: 5, right: 0)
        return textView
    }()
    
    let shadowView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(backgroundImageView)
        backgroundImageView.anchorToTop(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        addSubview(shadowView)
        shadowView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        shadowView.addSubview(titleLabel)
        titleLabel.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let title = hotelMenu?.title?.trimingAllSpacesAndNewLines, title.count == 0 { return }
        
        if let layers = shadowView.layer.sublayers {
            
            if layers.count == 2 {
                return
            }
        }
        
        let blackColor = UIColor.black.withAlphaComponent(0.5)
        shadowView.setGradientBackgroundUIView(colors: [blackColor, .clear])
    }
}

extension HotelMenuCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let size = CGSize(width: frame.width - 20, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height + 5
            }
        }
        
    }
    
}

extension HotelMenuCell {
    
    func setupHotelMenu(_ hotelMenu: HotelMenu) {
        if let imageUrl = hotelMenu.backgroundImageUrl {
            
            let imageUrls = imageUrl.components(separatedBy: ",")
            
            if imageUrls.count > 0 {
                let url = imageUrls[0]
                if GlobalFunction.isContainedString("http", of: url) {
                    self.backgroundImageView.loadSDWebImageWithUrlString(url)
                    
                } else {
                    self.backgroundImageView.image = UIImage(named: url)
                }
            }
            
            
        }
        
        if let title = hotelMenu.title {
            self.titleLabel.text = title
            textViewDidChange(titleLabel)
        }
    }
    
}
