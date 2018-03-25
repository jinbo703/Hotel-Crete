//
//  QuestionnaireRatingCell.swift
//  HotelCrete
//
//  Created by John Nik on 25/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import HCSStarRatingView

class QuestionnaireRatingCell: UITableViewHeaderFooterView {
    
    var questionnaireController: QuestionnaireController?
    
    let containerView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "Overall Rating".localized()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    lazy var ratingStarView: HCSStarRatingView = {
        
        let view = HCSStarRatingView()
        view.maximumValue = 5
        view.minimumValue = 0
        view.value = 0
        view.tintColor = StyleGuideManager.mainLightBlueBackgroundColor
        view.allowsHalfStars = false
        view.addTarget(self, action: #selector(didChangeRatingValue(sender:)), for: .valueChanged)
        return view
    }()
    
    let ratingTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = .darkGray
        textView.layer.cornerRadius = 5
        textView.layer.masksToBounds = true
        return textView
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit".localized(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.backgroundColor = StyleGuideManager.mainLightBlueBackgroundColor
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension QuestionnaireRatingCell {
    
    @objc fileprivate func handleSubmit() {
        
        let comments = ratingTextView.text
        
        questionnaireController?.handleSubmit(comments: comments)
        
    }
    
    @objc fileprivate func didChangeRatingValue(sender: HCSStarRatingView) {
        
        let value = sender.value
        
        questionnaireController?.handleRatingValue(Int(value))
    }
    
}

extension QuestionnaireRatingCell {
    
    fileprivate func setupViews() {
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        containerView.addSubview(ratingStarView)
        ratingStarView.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 130, height: 0)
        
        containerView.addSubview(ratingLabel)
        ratingLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: ratingStarView.leftAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(ratingTextView)
        ratingTextView.anchor(top: containerView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 150)
        
        addSubview(submitButton)
        submitButton.anchor(top: ratingTextView.bottomAnchor, left: ratingStarView.leftAnchor, bottom: nil, right: ratingStarView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
    }
}
