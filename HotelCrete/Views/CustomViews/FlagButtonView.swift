//
//  FlagButtonView.swift
//  HotelCrete
//
//  Created by John Nik on 15/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import Localize_Swift

enum Flag: String {
    
    case england = "English"
    case germany = "German"
    case russia = "Russian"
    case france = "French"
    case italy = "Italian"
}

enum DisplayName: String {
    
    case england = "en"
    case germany = "de"
    case russia = "ru"
    case france = "fr"
    case italy = "it"
}

let FLAG_BUTTON_PADDING: CGFloat = 7.5

protocol FlagButtonViewDelegate {
    
    func handleFlagButtonView(sender: FlagButtonView, isButtonSelected: Bool)
    
}

class FlagButtonView: UIView {
    
    var delegate: FlagButtonViewDelegate?
    var displayName: DisplayName?
    var flag: Flag? {
        
        didSet {
            
            guard let flag = flag else { return }
            self.flagLabel.text = flag.rawValue.localized(using: "ButtonTitles")
            
            let image = UIImage(named: flag.rawValue)
            self.flagButton.setBackgroundImage(image, for: .normal)
        }
    }
    
    lazy var flagButton: UIButton_FamAnimation = {
        let button = UIButton_FamAnimation(frame: .zero)
        let image = UIImage(named: AssetName.england.rawValue)
        button.setBackgroundImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleFlagButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    let flagLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = StyleGuideManager.mainLightBlueBackgroundColor
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleFlagButton(sender: UIButton_FamAnimation) {
        
        let isButtonSelected = flagButton.isSelected
        
        if isButtonSelected {
            return 
        }
        
        flagButton.setSelected(!isButtonSelected, withAnimation: true)
        
        if isButtonSelected {
            self.flagLabel.font = UIFont.systemFont(ofSize: 15)
            
        } else {
            self.flagLabel.font = UIFont.boldSystemFont(ofSize: 15)
        }
        
        delegate?.handleFlagButtonView(sender: self, isButtonSelected: isButtonSelected)
    }
    
}

extension FlagButtonView {
    
    fileprivate func setupViews() {
        
        let flagImageWidth: CGFloat = 256
        let flagImageHeight: CGFloat = 168
        
        
        let frameWidth = DEVICE_WIDTH / 5 - FLAG_BUTTON_PADDING * 2
        let height = (frameWidth - FLAG_BUTTON_PADDING * 2) * flagImageHeight / flagImageWidth
        
        addSubview(flagButton)
        flagButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: FLAG_BUTTON_PADDING, paddingBottom: 0, paddingRight: FLAG_BUTTON_PADDING, width: 0, height: height)
        
        
        addSubview(flagLabel)
        flagLabel.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
    }
}
