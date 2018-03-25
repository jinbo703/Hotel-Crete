//
//  MessageCell.swift
//  HotelCrete
//
//  Created by John Nik on 26/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class MessageCell: BaseCollectionViewCell {
    
    
    var message: Message.ChatInfo? {
        
        didSet {
            
            guard let message = message else { return }
            
            if let messageText = message.msg, let date = message.created_date, let hotelName = UserDefaults.standard.getHotelName() {
                
                let attributedText = GlobalFunction.getAttributedString(firstString: hotelName + ":\n", secondString: "  " + messageText + "\n  " + date)
                self.textView.attributedText = attributedText
                
            }
        }
    }
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = StyleGuideManager.messageTextViewBackgroundLightColor
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.layer.cornerRadius = 5
        textView.layer.masksToBounds = true
        textView.textColor = .black
        
        return textView
    }()
    
    override func setupViews() {
        
        super.setupViews()
        
        addSubview(textView)
        
        textView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 20, paddingBottom: 5, paddingRight: 20, width: 0, height: 0)
    }
    
}
