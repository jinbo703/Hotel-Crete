//
//  GuideCreteDataAreaListController.swift
//  HotelCrete
//
//  Created by John Nik on 26/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class GuideCreteDataAreaListController: CreteMenuController {
    
    var guideDataDetails: [Crete.GuideDataDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(GuideCreteDataAreaListCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func fetchData() {}
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guideDataDetails.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GuideCreteDataAreaListCell
        cell.guideCreteDataAreaListController = self
        cell.guideDataDetail = guideDataDetails[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let guideDataDetail = guideDataDetails[indexPath.item]
        
        let directionController = GuideCreteDataAreaDirectionController(collectionViewLayout: UICollectionViewFlowLayout())
        directionController.navigationItem.title = getLocalizedString(from: guideDataDetail, type: .title)
        directionController.guideCreteDatas = [guideDataDetail]
        directionController.guideCreteDataAreaListController = self
        navigationController?.pushViewController(directionController, animated: true)
    }
    
}

extension GuideCreteDataAreaListController {
    func getLocalizedString(from detail: Crete.GuideDataDetail, type: StringType) -> String? {
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
