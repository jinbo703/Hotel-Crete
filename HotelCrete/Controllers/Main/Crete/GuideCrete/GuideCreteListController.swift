//
//  GuideCreteListController.swift
//  HotelCrete
//
//  Created by John Nik on 24/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class GuideCreteListController: CreteMenuController {
    
    var guideCreteInfo: Crete.GuideCreteInfo?
    
    var guideCreteLists: [Crete.GuideList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(GuideCreteListCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func fetchData() {
        
        guard let guideCreteInfo = guideCreteInfo else { return }
        
        if let guideCreteLists = guideCreteInfo.GuideList {
            self.guideCreteLists = guideCreteLists
            self.collectionView?.reloadData()
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guideCreteLists.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GuideCreteListCell
        cell.guideCreteListController = self
        cell.guideCreteList = guideCreteLists[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let guideCreteList = guideCreteLists[indexPath.item]
        
        let sightSeeingController = GuideCreteSightSeeingController(collectionViewLayout: UICollectionViewFlowLayout())
        sightSeeingController.guideCreteLists = [guideCreteList]
        sightSeeingController.navigationItem.title = getLocalizedString(from: guideCreteList)
        
        navigationController?.pushViewController(sightSeeingController, animated: true)
    }
    
}

extension GuideCreteListController {
    func getLocalizedString(from detail: Crete.GuideList?) -> String? {
        var string: String?
        
        if currentLanguage() == DisplayName.england.rawValue {
            string = detail?.title
        } else if currentLanguage() == DisplayName.france.rawValue {
            string = detail?.title_french
        } else if currentLanguage() == DisplayName.germany.rawValue {
            string = detail?.title_german
        } else if currentLanguage() == DisplayName.italy.rawValue {
            string = detail?.title_italian
        } else {
            string = detail?.title_russian
        }
        
        return string
    }
}
