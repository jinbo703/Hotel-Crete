//
//  GuideCreteSightSeeingDetailDirectionController.swift
//  HotelCrete
//
//  Created by John Nik on 26/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class GuideCreteSightSeeingDetailDirectionController: DescriptionController {
    
    var guideCreteListDetails: [Crete.GuideListDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(GuideCreteSightSeeingDetailDirectionCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guideCreteListDetails.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GuideCreteSightSeeingDetailDirectionCell
         cell.guideCreteSightSeeingController = self
        cell.guideCreteListDetail = guideCreteListDetails[indexPath.item]
       
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height: CGFloat = INTRODUCTION_IMAGE_HEIGHT + 50
        if let detail = getLocalizedString(from: guideCreteListDetails[indexPath.item]) {
            let estimatedHeight = GlobalFunction.estimateFrameForText(text: detail.htmlToString, width: width - 40, font: 15.0).height
            return CGSize(width: width, height: height + estimatedHeight)
        }
        
        return CGSize(width: width, height: height)
    }
    
}

extension GuideCreteSightSeeingDetailDirectionController {
    func getLocalizedString(from detail: Crete.GuideListDetail) -> String? {
        var string: String?
        
        if currentLanguage() == DisplayName.england.rawValue {
            string = detail.description
        } else if currentLanguage() == DisplayName.france.rawValue {
            string = detail.description_french
        } else if currentLanguage() == DisplayName.germany.rawValue {
            string = detail.description_german
        } else if currentLanguage() == DisplayName.italy.rawValue {
            string = detail.description_italian
        } else {
            string = detail.description_russian
        }
        
        return string
    }
}
