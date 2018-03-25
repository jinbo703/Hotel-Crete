//
//  GuideCreteSightSeeingcontroller.swift
//  HotelCrete
//
//  Created by John Nik on 26/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class GuideCreteSightSeeingController: DescriptionController {
    
    var guideCreteLists: [Crete.GuideList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(GuideCreteSightSeeingCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    
    override func didTappedMapSegment(index: Int, marker: HotelMarker) {
        if index == 0 {
            
            if guideCreteLists.count > 0 {
                guard let guideCreteDetails = guideCreteLists[0].GuideSightseeing else { return }
                
                let sightSeeingDetailController = GuideCreteSightSeeingDetailController(collectionViewLayout: UICollectionViewFlowLayout())
                sightSeeingDetailController.guideCreteListDetails = guideCreteDetails
                sightSeeingDetailController.navigationItem.title = getLocalizedString(from: guideCreteLists[0], type: .title)
                self.navigationController?.pushViewController(sightSeeingDetailController, animated: true)
            }
        } else if index == 1 {
            self.handleShowMarker(marker)
        } else {
            self.handleNavigationTo(marker: marker)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guideCreteLists.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GuideCreteSightSeeingCell
        cell.guideCreteSightSeeingController = self
        cell.guideCreteList = guideCreteLists[indexPath.item]
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height: CGFloat = INTRODUCTION_IMAGE_HEIGHT + 50
        if let detail = getLocalizedString(from: guideCreteLists[indexPath.item], type: .description) {
            let estimatedHeight = GlobalFunction.estimateFrameForText(text: detail.htmlToString, width: width - 40, font: 15.0).height
            return CGSize(width: width, height: height + estimatedHeight)
        }
        
        return CGSize(width: width, height: height)
    }
    
}

extension GuideCreteSightSeeingController {
    func getLocalizedString(from detail: Crete.GuideList, type: StringType) -> String? {
        var string: String?
        
        if currentLanguage() == DisplayName.england.rawValue {
            if type == .title {
                string = detail.title
            } else {
                string = detail.description
            }
            
        } else if currentLanguage() == DisplayName.france.rawValue {
            if type == .title {
                string = detail.title_french
            } else {
                string = detail.description_french
            }
            
        } else if currentLanguage() == DisplayName.germany.rawValue {
            if type == .title {
                string = detail.title_german
            } else {
                string = detail.description_german
            }
            
        } else if currentLanguage() == DisplayName.italy.rawValue {
            if type == .title {
                string = detail.title_italian
            } else {
                string = detail.description_italian
            }
            
        } else {
            if type == .title {
                string = detail.title_russian
            } else {
                string = detail.description_russian
            }
            
        }
        
        return string
    }
}
