//
//  GuideCreteSightSeeingDetailController.swift
//  HotelCrete
//
//  Created by John Nik on 26/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class GuideCreteSightSeeingDetailController: CreteMenuController {
    
    var guideCreteListDetails: [Crete.GuideListDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(GuideCreteSightSeeingDetailCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func fetchData() {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guideCreteListDetails.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GuideCreteSightSeeingDetailCell
        cell.guideCreteSightSeeingDetailController = self
        cell.guideListDetail = guideCreteListDetails[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let guideCreteListDetail = guideCreteListDetails[indexPath.item]
        
        let directionControlleller = GuideCreteSightSeeingDetailDirectionController(collectionViewLayout: UICollectionViewFlowLayout())
        directionControlleller.guideCreteListDetails = [guideCreteListDetail]
        directionControlleller.navigationItem.title = getLocalizedString(from: guideCreteListDetail)
        navigationController?.pushViewController(directionControlleller, animated: true)
    }
}

extension GuideCreteSightSeeingDetailController {
    func getLocalizedString(from detail: Crete.GuideListDetail) -> String? {
        var string: String?
        
        if currentLanguage() == DisplayName.england.rawValue {
            string = detail.title
        } else if currentLanguage() == DisplayName.france.rawValue {
            string = detail.title_french
        } else if currentLanguage() == DisplayName.germany.rawValue {
            string = detail.title_german
        } else if currentLanguage() == DisplayName.italy.rawValue {
            string = detail.title_italian
        } else {
            string = detail.title_russian
        }
        
        return string
    }
}
