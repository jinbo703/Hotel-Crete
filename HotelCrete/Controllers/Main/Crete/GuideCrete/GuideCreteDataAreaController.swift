//
//  GuideCreteDataAreaController.swift
//  HotelCrete
//
//  Created by John Nik on 26/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class GuideCreteDataAreaController: CreteMenuController {
    
    var guideDataDetails: [Crete.GuideDataDetail] = []
    
    var beacheRegions: [Crete.BeachRegion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(GuideCreteDataAreaCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func fetchData() {
        
        guard ReachabilityManager.shared.internetIsUp else {
            
            self.showPMAlertOkay(title: "Internet Error", message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        
        APIService.sharedInstance.handleGetGuideCreteBeacheRegion { (result: Crete.ResultBeachRegion) in
            
            switch result {
            case .failure(_):
                self.showErrorMessage(title: "Server Error", message: AlertMessages.somethingWentWrong.rawValue)
            case .success(let response):
                if let beaches = response.result {
                    self.fetchBeachRegions(beaches)
                }
            }
            
        }
        
    }
    
    fileprivate func fetchBeachRegions(_ beaches: [Crete.BeachRegion]) {
        
        
        for beach in beaches {
            
            let beachRegionInfo = beach.BeachRegion
            
            var details: [Crete.GuideDataDetail] = []
            
            for guideDataDetail in self.guideDataDetails {
                
                if beachRegionInfo?.region == guideDataDetail.region {
                    details.append(guideDataDetail)
                }
                
            }
            
            let beachRegion = Crete.BeachRegion(BeachRegion: beachRegionInfo, beaches: details)
            
            self.beacheRegions.append(beachRegion)
        }
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return beacheRegions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GuideCreteDataAreaCell
        cell.guideCreteDataAreaController = self
        cell.beachRegion = beacheRegions[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let guideDataDetails = beacheRegions[indexPath.item].beaches else { return }
        
        let areaListController = GuideCreteDataAreaListController(collectionViewLayout: UICollectionViewFlowLayout())
        areaListController.navigationItem.title = getLocalizedString(from: beacheRegions[indexPath.item].BeachRegion)
        areaListController.guideDataDetails = guideDataDetails
        
        self.navigationController?.pushViewController(areaListController, animated: true)
    }
    
}

extension GuideCreteDataAreaController {
    func getLocalizedString(from detail: Crete.BeachRegionInfo?) -> String? {
        var string: String?
        
        if currentLanguage() == DisplayName.england.rawValue {
            string = detail?.region
        } else if currentLanguage() == DisplayName.france.rawValue {
            string = detail?.region_french
        } else if currentLanguage() == DisplayName.germany.rawValue {
            string = detail?.region_german
        } else if currentLanguage() == DisplayName.italy.rawValue {
            string = detail?.region_italian
        } else {
            string = detail?.region_russian
        }
        
        return string
    }
}
