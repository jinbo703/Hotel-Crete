//
//  GuideCreteDataGeneralController.swift
//  HotelCrete
//
//  Created by John Nik on 25/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class GuideCreteDataGeneralController: CreteMenuController {
    
    var guideCreteInfo: Crete.GuideCreteInfo?
    var guideCreteDatas: [Crete.GuideData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(GuideCreteDataGeneralCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func fetchData() {
        
        guard let guideCreteInfo = guideCreteInfo else { return }
        
        if let guideCreteDatas = guideCreteInfo.GuideData {
            self.guideCreteDatas = guideCreteDatas
            self.collectionView?.reloadData()
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guideCreteDatas.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GuideCreteDataGeneralCell
        cell.guideCreteDataGeneralController = self
        cell.guideCreteData = guideCreteDatas[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let guideCreteData = guideCreteDatas[indexPath.row]
        
        let directionController = GuideCreteDataGeneralDirectionController(collectionViewLayout: UICollectionViewFlowLayout())
        directionController.navigationItem.title = getLocalizedString(from: guideCreteData, type: .title)
        directionController.guideCreteDatas = [guideCreteData]
        directionController.guideCreteDataGeneralController = self
        navigationController?.pushViewController(directionController, animated: true)
        
    }
    
}

extension GuideCreteDataGeneralController {
    func getLocalizedString(from detail: Crete.GuideData, type: StringType) -> String? {
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
