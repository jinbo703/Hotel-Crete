//
//  GuideCreteDataAreaDirectionCell.swift
//  HotelCrete
//
//  Created by John Nik on 26/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import ImageSlideshow
import CoreLocation

class GuideCreteDataAreaDirectionCell: CreteExtraDetailGuideCell {
    
    var directionController: GuideCreteDataAreaDirectionController?
    
    var guideCreteData: Crete.GuideDataDetail? {
        
        didSet {
            
            guard let guideCreteData = guideCreteData else { return }
            setupGuideCreteData(guideCreteData)
        }
    }
    
    func setupGuideCreteData(_ guideCreteData: Crete.GuideDataDetail) {
        
        if let images = guideCreteData.image, images.count > 0 {
            
            let imageUrls = images.components(separatedBy: ",")
            
            var localSource = [InputSource]()
            
            for imageUrl in imageUrls {
                if let url = GlobalFunction.getUrlFromString(imageUrl) {
                    
                    let imageSource = SDWebImageSource(url: url)
                    localSource.append(imageSource)
                }
            }
            
            self.imageSlideShow.setImageInputs(localSource)
            
        }
        
        
        self.detailTextView.attributedText = directionController?.guideCreteDataAreaListController?.getLocalizedString(from: guideCreteData, type: .description)?.htmlToAttributedString
        
    }
    
    override func setupViews() {
        super.setupViews()
    }
    
    override func didTap() {
        guard let directionController = directionController else { return }
        imageSlideShow.presentFullScreenController(from: directionController)
    }
    
    override func handleSegmentControl(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        sender.selectedSegmentIndex = UISegmentedControlNoSegment
        
        guard let idString = guideCreteData?.id else { return }
        
        guard let latitude = guideCreteData?.latitude, let longitude = guideCreteData?.longitude else { return }
        let latArr = latitude.components(separatedBy: ",")
        
        if let id = Int(idString), let lat = Double(latArr[0].trimmingCharacters(in: .whitespacesAndNewlines)), let long = Double(longitude.trimmingCharacters(in: .whitespacesAndNewlines)) {
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
            let hotelPlace = HotelMap.HotelPlace(id: id, region: nil, region_greek: nil, coordinate: coordinate)
            
            let marker = HotelMarker(place: hotelPlace)
            
            directionController?.didTappedMapSegment(index: index, marker: marker)
        }
    }
}
