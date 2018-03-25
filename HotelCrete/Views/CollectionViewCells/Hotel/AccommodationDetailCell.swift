//
//  AccommodationDetailCell.swift
//  HotelCrete
//
//  Created by John Nik on 24/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import ImageSlideshow

class AccommodationDetailCell: IntroductionCell {
    
    var accommodationDetailController: AccommodationDetailController?
    
    var detail: HotelMenu? {
        
        didSet {
            guard let detail = detail else { return }
            self.setupDetail(detail)
        }
    }
    
    override func setupViews() {
        super.setupViews()
       
    }
    
    func setupDetail(_ detail: HotelMenu) {
        
        if let imageString = detail.backgroundImageUrl {
            var localSource = [InputSource]()
            
            let images = imageString.components(separatedBy: ",")
            
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
        
        if let description = detail.description, let title = detail.title {
            
            let attributedString = GlobalFunction.getAttributedStringFromHtml(description, title: title)
            
            self.detailTextView.attributedText = attributedString
        }
        
    }
    
    override func didTap() {
        guard let accommodationDetailController = accommodationDetailController else { return }
        imageSlideShow.presentFullScreenController(from: accommodationDetailController)
    }
}
