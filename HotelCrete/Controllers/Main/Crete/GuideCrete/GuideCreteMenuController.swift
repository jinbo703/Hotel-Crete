//
//  GuideCreteMenuController.swift
//  HotelCrete
//
//  Created by John Nik on 24/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class GuideCreteMenuController: CreteMenuController {
    
    var guideCreteInfos: [Crete.GuideCreteInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(GuideCreteMenuCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func fetchData() {
        
        guard ReachabilityManager.shared.internetIsUp else {
            
            self.showPMAlertOkay(title: "Internet Error", message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        
        
        
        APIService.sharedInstance.handleGetGuideCrete { (result: Crete.ResultGuideCrete) in
            
            switch result {
            case .failure(_):
                self.showErrorMessage(title: "Server Error", message: AlertMessages.somethingWentWrong.rawValue)
            case .success(let response):
                if let guideCreteInfos = response.result {
                    self.setupGuideCreteInfos(guideCreteInfos)
                }
            }
            
        }
        
    }
    
    func setupGuideCreteInfos(_ guideCreteInfos: [Crete.GuideCreteInfo]) {
        
        self.guideCreteInfos = guideCreteInfos
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guideCreteInfos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GuideCreteMenuCell
        cell.guideCreteMenuController = self
        cell.guideCrete = guideCreteInfos[indexPath.item].GuideCrete
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let guideCreteInfo = guideCreteInfos[indexPath.item]
        
        if let guideCreteLists = guideCreteInfo.GuideList, guideCreteLists.count > 0 {
            let guideListController = GuideCreteListController(collectionViewLayout: UICollectionViewFlowLayout())
            guideListController.guideCreteInfo = guideCreteInfo
            guideListController.navigationItem.title = getLocalizedString(from: guideCreteInfo.GuideCrete)
            self.navigationController?.pushViewController(guideListController, animated: true)
        } else if let guideData = guideCreteInfo.GuideData, guideData.count > 0 {
            
            if let beaches = guideData[0].GuideBeache, beaches.count > 0 {
                let guideCreteDataController = GuideCreteDataController()
                guideCreteDataController.guideCreteInfo = guideCreteInfo
                guideCreteDataController.navigationItem.title = getLocalizedString(from: guideCreteInfo.GuideCrete)
                self.navigationController?.pushViewController(guideCreteDataController, animated: true)
            } else {
                
                let guideCreteDataGeneralController = GuideCreteDataGeneralController(collectionViewLayout: UICollectionViewFlowLayout())
                guideCreteDataGeneralController.guideCreteInfo = guideCreteInfo
                guideCreteDataGeneralController.navigationItem.title = getLocalizedString(from: guideCreteInfo.GuideCrete)
                self.navigationController?.pushViewController(guideCreteDataGeneralController, animated: true)
            }
        } else {
            let guideCreteGeneralController = GuideCreteGeneralController(collectionViewLayout: UICollectionViewFlowLayout())
            guideCreteGeneralController.navigationItem.title = getLocalizedString(from: guideCreteInfo.GuideCrete)
            guideCreteGeneralController.guideCreteInfo = guideCreteInfo
            self.navigationController?.pushViewController(guideCreteGeneralController, animated: true)
        }
    }
    
}

extension GuideCreteMenuController {
    func getLocalizedString(from detail: Crete.GuideCrete?) -> String? {
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
