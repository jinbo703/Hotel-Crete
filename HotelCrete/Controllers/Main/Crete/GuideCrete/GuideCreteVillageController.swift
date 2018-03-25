//
//  GuideCreteVillageController.swift
//  HotelCrete
//
//  Created by John Nik on 02/03/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class GuideCreteVillageController: GuideCreteSightSeeingDetailController {
    
    var region: String? {
        didSet {
            navigationItem.title = region
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func fetchData() {
        
        guard ReachabilityManager.shared.internetIsUp else {
            
            self.showPMAlertOkay(title: "Internet Error", message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        
        guard let region = region else { return }
        
        let guideVillage = Crete.Region(region: region)
        let request = Crete.RequestGuideVillage(GuideVillage: guideVillage)
        
        APIService.sharedInstance.handleGetGuideCreteVillages(request) { (result: Crete.ResultGuideVillage) in
            
            switch result {
            case .failure(_):
                self.showErrorMessage(title: "Server Error", message: AlertMessages.somethingWentWrong.rawValue)
            case .success(let response):
                if let guideCreteListDetails = response.result {
                    
                    for detail in guideCreteListDetails {
                        if let guideVillage = detail.GuideVillage {
                            self.guideCreteListDetails.append(guideVillage)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
            }
            
        }
        
    }
    
}
