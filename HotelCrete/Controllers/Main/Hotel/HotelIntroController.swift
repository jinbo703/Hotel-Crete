//
//  HotelIntroController.swift
//  HotelCrete
//
//  Created by John Nik on 17/03/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class HotelIntroController: DescriptionController {
    
    var isRussian: Bool = false
    
    var hotelAbouts: [Hotel.HotelAbout]? {
        
        didSet {
            self.fetchHotelAbouts()
        }
    }
    
    var introductions: [Introduction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(HotelIntroCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return introductions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HotelIntroCell
        cell.hotelIntroController = self
        cell.introduction = introductions[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height: CGFloat = INTRODUCTION_IMAGE_HEIGHT + 50
        
        let introduction = introductions[indexPath.item]
        if let detail = introduction.detail, let title = introduction.title {
            
            let attributedString = GlobalFunction.getAttributedStringFromHtml(detail, title: title).string
            let estimatedHeight = GlobalFunction.estimateFrameForText(text: attributedString, width: width - 40, font: 18.0).height
            
            var extraHeight: CGFloat = 20
            if isRussian {
              extraHeight = 300
            }
            
            return CGSize(width: width, height: height + estimatedHeight + extraHeight)
        }
        
        
        return CGSize(width: width, height: height)
    }
    
    func fetchHotelAbouts() {
        
        guard let hotelAbouts = self.hotelAbouts else { return }
        
        var images: [String] = []
        var detail: String?
        var title: String?
        var latitude: String?
        var longitude: String?
        
        for hotelAbout in hotelAbouts {
            
            if let imageUrl = hotelAbout.About?.image {
                images.append(imageUrl)
            } else {
                images.append("Untitled-4.jpg")
            }
            detail = hotelAbouts[0].addhotels?.description
            title = hotelAbouts[0].addhotels?.hotelname
            latitude = hotelAbouts[0].addhotels?.latitude
            longitude = hotelAbouts[0].addhotels?.longitude
        }
        
        if hotelAbouts.count > 0 {
            
            let addHotel = hotelAbouts[0].addhotels
            if currentLanguage() == DisplayName.england.rawValue {
                title = addHotel?.hotelname
                detail = addHotel?.description
            } else if currentLanguage() == DisplayName.france.rawValue {
                title = addHotel?.hotelname_french
                detail = addHotel?.description_french
            } else if currentLanguage() == DisplayName.germany.rawValue {
                title = addHotel?.hotelname_german
                detail = addHotel?.description_german
            } else if currentLanguage() == DisplayName.italy.rawValue {
                title = addHotel?.hotelname_italian
                detail = addHotel?.description_italian
            } else {
                title = addHotel?.hotelname_russian
                detail = addHotel?.description_russian
                
                isRussian = true
            }
        }
        
        let introduction = Introduction(images: images, title: title, detail: detail, latitude: latitude, longitude: longitude)
        navigationItem.title = introduction.title
        introductions.append(introduction)
        collectionView?.reloadData()
        
    }
    
}
