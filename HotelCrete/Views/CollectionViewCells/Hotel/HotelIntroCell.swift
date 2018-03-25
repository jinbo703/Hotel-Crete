//
//  HotelIntroCell.swift
//  HotelCrete
//
//  Created by John Nik on 17/03/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import ImageSlideshow
import CoreLocation

class HotelIntroCell: CreteExtraDetailGuideCell {
    
    var hotelIntroController: HotelIntroController?
    
    var introduction: Introduction? {
        
        didSet {
            guard let introduction = introduction else { return }
            
            self.setupIntorduction(introduction)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
    }
    
    override func handleSegmentControl(_ sender: UISegmentedControl) {
        
        let index = sender.selectedSegmentIndex
        sender.selectedSegmentIndex = UISegmentedControlNoSegment
        
        guard let latitude = introduction?.latitude, let longitude = introduction?.longitude else { return }
        
        if let lat = Double(latitude.trimmingCharacters(in: .whitespacesAndNewlines)), let long = Double(longitude.trimmingCharacters(in: .whitespacesAndNewlines)) {
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
            let hotelPlace = HotelMap.HotelPlace(id: 0, region: nil, region_greek: nil, coordinate: coordinate)
            
            let marker = HotelMarker(place: hotelPlace)
            
            hotelIntroController?.didTappedMapSegment(index: index, marker: marker)
        }
    }
    
    override func didTap() {
        guard let hotelIntroController = hotelIntroController else { return }
        imageSlideShow.presentFullScreenController(from: hotelIntroController)
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
