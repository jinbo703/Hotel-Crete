//
//  CreteExtraDetailGuideCell.swift
//  HotelCrete
//
//  Created by John Nik on 24/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import ImageSlideshow
import CoreLocation
class CreteExtraDetailGuideCell: BaseCollectionViewCell {
    
    var creteExtraDetailGuideController: CreteExtraDetailGuideController?
    
    var creteExtraDetail: Crete.CreteExtraDetail? {
        
        didSet {
            guard let creteExtraDetail = creteExtraDetail else { return }
            
            self.setupCreteExtraDetail(creteExtraDetail)
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
    
    lazy var segmentControl: UISegmentedControl = {
        
        let segement = UISegmentedControl(items: ["Map".localized(), "Direction".localized()])
        segement.tintColor = StyleGuideManager.mainLightBlueBackgroundColor
        segement.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)], for: .normal)
        segement.addTarget(self, action: #selector(handleSegmentControl(_:)), for: .valueChanged)
        return segement
    }()
    
    override func setupViews() {
        super.setupViews()
        
        setupSlideView()
        setupSegment()
        setupTextView()
    }
    
    func setupCreteExtraDetail(_ detail: Crete.CreteExtraDetail) {
        
        if let images = detail.image, images.count > 0 {
            
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
        
        self.detailTextView.attributedText = creteExtraDetailGuideController?.getLocalizedString(from: detail)?.htmlToAttributedString
        
    }
    
    
    
    @objc func handleSegmentControl(_ sender: UISegmentedControl) {
        
        let index = sender.selectedSegmentIndex
        sender.selectedSegmentIndex = UISegmentedControlNoSegment
        
        guard let idString = creteExtraDetail?.id else { return }
        
        guard let latitude = creteExtraDetail?.latitude, let longitude = creteExtraDetail?.longitude else { return }
        let latArr = latitude.components(separatedBy: ",")
        
        if let id = Int(idString), let lat = Double(latArr[0].trimingAllSpacesAndNewLines), let long = Double(longitude.trimingAllSpacesAndNewLines) {
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
            let hotelPlace = HotelMap.HotelPlace(id: id, region: nil, region_greek: nil, coordinate: coordinate)
            
            let marker = HotelMarker(place: hotelPlace)
            
            creteExtraDetailGuideController?.didTappedMapSegment(index: index, marker: marker)
        }
        
    }
    
    @objc func didTap() {
        guard let creteExtraDetailGuideController = creteExtraDetailGuideController else { return }
        imageSlideShow.presentFullScreenController(from: creteExtraDetailGuideController)
    }
}

extension CreteExtraDetailGuideCell {
    
    fileprivate func setupSegment() {
        
        addSubview(segmentControl)
        segmentControl.anchor(top: imageSlideShow.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 2, paddingLeft: 2, paddingBottom: 0, paddingRight: 2, width: 0, height: 40)
    }
    
    fileprivate func setupTextView() {
        addSubview(detailTextView)
        detailTextView.anchor(top: segmentControl.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 2, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
    }
    
    fileprivate func setupSlideView() {
        addSubview(imageSlideShow)
        imageSlideShow.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: INTRODUCTION_IMAGE_HEIGHT)
    }
}
