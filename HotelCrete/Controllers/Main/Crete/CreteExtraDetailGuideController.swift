//
//  CreteExtraDetailGuideController.swift
//  HotelCrete
//
//  Created by John Nik on 24/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import ImageSlideshow


class CreteExtraDetailGuideController: DescriptionController {
    
    var creteExtraDetails: [Crete.CreteExtraDetail] = []    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(CreteExtraDetailGuideCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return creteExtraDetails.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CreteExtraDetailGuideCell
        cell.creteExtraDetailGuideController = self
        cell.creteExtraDetail = creteExtraDetails[indexPath.item]
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height: CGFloat = INTRODUCTION_IMAGE_HEIGHT + 50
        if let detail = getLocalizedString(from: creteExtraDetails[indexPath.item]) {
            let estimatedHeight = GlobalFunction.estimateFrameForText(text: detail.htmlToString, width: width - 40, font: 15.0).height
            return CGSize(width: width, height: height + estimatedHeight)
        }
        
        
        return CGSize(width: width, height: height)
    }
    
    func getLocalizedString(from data: Crete.CreteExtraDetail) -> String? {
        var string: String?
        
        if currentLanguage() == DisplayName.england.rawValue {
            string = data.description
        } else if currentLanguage() == DisplayName.france.rawValue {
            string = data.description_french
        } else if currentLanguage() == DisplayName.germany.rawValue {
            string = data.description_german
        } else if currentLanguage() == DisplayName.italy.rawValue {
            string = data.description_italian
        } else {
            string = data.description_russian
        }
        
        return string
    }
}



