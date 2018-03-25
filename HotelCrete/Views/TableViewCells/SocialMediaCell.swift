//
//  SocialMediaCell.swift
//  HotelCrete
//
//  Created by John Nik on 23/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setSocialButton(title: String) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        self.backgroundColor = UIColor(white: 1, alpha: 0.2)
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
}

class SocialMediaCell: BaseTableViewCell {
    
    var socialMediaController: SocialMediaController?
    
    var socialMedia: SocialMedia? {
        
        didSet {
            if let title = socialMedia?.title {
                self.socialButton.setTitle(title, for: .normal)
            }
        }
    }
    
    lazy var socialButton: UIButton = {
        let button = UIButton(type: .system)
        button.setSocialButton(title: "")
        button.addTarget(self, action: #selector(handleSocialButton), for: .touchUpInside)
        return button
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(socialButton)
        socialButton.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 40)
        socialButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        
    }
    
    @objc func handleSocialButton() {
        if let link = self.socialMedia?.link {
            self.socialMediaController?.handleSocialButton(link: link)
        }
    }
    
}
