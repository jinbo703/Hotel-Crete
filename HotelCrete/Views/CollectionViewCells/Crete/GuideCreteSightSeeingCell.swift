//
//  GuideCreteSightSeeingCell.swift
//  HotelCrete
//
//  Created by John Nik on 26/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import ImageSlideshow
import CoreLocation

class GuideCreteSightSeeingCell: CreteExtraDetailGuideCell {
    
    var guideCreteSightSeeingController: GuideCreteSightSeeingController?
    
    var guideCreteList: Crete.GuideList? {
        
        didSet {
            
            guard let guideCreteList = guideCreteList else { return }
            setupGuideCreteList(guideCreteList)
        }
    }
    
    func setupGuideCreteList(_ guideCreteList: Crete.GuideList) {
        
        if let images = guideCreteList.image, images.count > 0 {
            
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
        
        
        self.detailTextView.attributedText = guideCreteSightSeeingController?.getLocalizedString(from: guideCreteList, type: .description)?.htmlToAttributedString
        
    }
    
    override func setupViews() {
        super.setupViews()
        
        segmentControl.segmentTitles = ["SightSeeing".localized(), "Map".localized(), "Direction".localized()]
    }
    
    override func didTap() {
        guard let guideCreteSightSeeingController = guideCreteSightSeeingController else { return }
        imageSlideShow.presentFullScreenController(from: guideCreteSightSeeingController)
    }
    
    override func handleSegmentControl(_ sender: UISegmentedControl) {
        
        let index = sender.selectedSegmentIndex
        sender.selectedSegmentIndex = UISegmentedControlNoSegment
        
        guard let idString = guideCreteList?.id else { return }
        
        guard let latitude = guideCreteList?.latitude, let longitude = guideCreteList?.longitude else { return }
        let latArr = latitude.components(separatedBy: ",")
        
        if let id = Int(idString), let lat = Double(latArr[0].trimmingCharacters(in: .whitespacesAndNewlines)), let long = Double(longitude.trimmingCharacters(in: .whitespacesAndNewlines)) {
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
            let hotelPlace = HotelMap.HotelPlace(id: id, region: nil, region_greek: nil, coordinate: coordinate)
            
            let marker = HotelMarker(place: hotelPlace)
            
            guideCreteSightSeeingController?.didTappedMapSegment(index: index, marker: marker)
        }
    }
}

