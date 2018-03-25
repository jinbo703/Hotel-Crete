//
//  IntroductionCell.swift
//  HotelCrete
//
//  Created by John Nik on 18/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import ImageSlideshow

let INTRODUCTION_IMAGE_HEIGHT: CGFloat = GAP100 * 2.1

class IntroductionCell: BaseCollectionViewCell {
    
    var introductionController: IntroductionController?
    
    var introduction: Introduction? {
        
        didSet {
            guard let introduction = introduction else { return }
            
            self.setupIntorduction(introduction)
        }
    }
    
    lazy var imageSlideShow: ImageSlideshow = {
        
        let slideShow = ImageSlideshow()
        slideShow.backgroundColor = UIColor.white
//        slideShow.slideshowInterval = 5.0

        slideShow.pageControlPosition = PageControlPosition.underScrollView
        slideShow.pageControl.currentPageIndicatorTintColor = UIColor.black
        slideShow.pageControl.pageIndicatorTintColor = UIColor.lightGray
        slideShow.contentScaleMode = .scaleAspectFill
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        slideShow.addGestureRecognizer(gestureRecognizer)
        return slideShow
    }()
    
    let detailTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textAlignment = .center
        textView.isScrollEnabled = false
        textView.isEditable = false
        
        return textView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        setupSlideView()
        setupTextView()
    }
    
    func setupIntorduction(_ introduction: Introduction) {
        
        if let images = introduction.images {
            var localSource = [InputSource]()
            
            for image in images {
                
                if GlobalFunction.isContainedString("http", of: image) {
                    if let url = GlobalFunction.getUrlFromString(image) {
                        
                        let imageSource = SDWebImageSource(url: url)
                        localSource.append(imageSource)
                    } else {
                        if let imageSource = ImageSource(imageString: image) {
                            localSource.append(imageSource)
                        }
                    }
                    
                } else {
                    if let imageSource = ImageSource(imageString: image) {
                        localSource.append(imageSource)
                    }
                }
            }
            
            self.imageSlideShow.setImageInputs(localSource)
        }
        
        if let detail = introduction.detail, let title = introduction.title {
            
            let attributedString = GlobalFunction.getAttributedStringFromHtml(detail, title: title)
            
            self.detailTextView.attributedText = attributedString
        }
    }
    
}

extension IntroductionCell {
    @objc func didTap() {
        guard let introductionController = introductionController else { return }
        imageSlideShow.presentFullScreenController(from: introductionController)
    }
}

extension IntroductionCell {
    fileprivate func setupTextView() {
        addSubview(detailTextView)
        detailTextView.anchor(top: imageSlideShow.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
    }
    
    fileprivate func setupSlideView() {
        addSubview(imageSlideShow)
        imageSlideShow.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: INTRODUCTION_IMAGE_HEIGHT)
    }
}
