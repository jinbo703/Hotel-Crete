//
//  AboutCreteMenuController.swift
//  HotelCrete
//
//  Created by John Nik on 24/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class AboutCreteMenuController: CreteMenuController {
    
    var aboutCreteInfos: [Crete.AboutCreteInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(AboutCreteMenuCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func fetchData() {
        
        guard ReachabilityManager.shared.internetIsUp else {
            
            self.showPMAlertOkay(title: "Internet Error", message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        
        APIService.sharedInstance.handleGetAboutCrete { (result: Crete.ResultAboutCrete) in
            
            switch result {
            case .failure(_):
                self.showErrorMessage(title: "Server Error", message: AlertMessages.somethingWentWrong.rawValue)
            case .success(let response):
                if let aboutCreteInfos = response.result {
                    self.setupAboutCreteInfos(aboutCreteInfos)
                }
            }
            
        }
        
    }
    
    func setupAboutCreteInfos(_ aboutCreteInfos: [Crete.AboutCreteInfo]) {
        
        self.aboutCreteInfos = aboutCreteInfos
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aboutCreteInfos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AboutCreteMenuCell
        
        cell.aboutCrete = aboutCreteInfos[indexPath.item].AboutCrete
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let aboutCreteInfo = aboutCreteInfos[indexPath.item]
        
        if let creteDetails = aboutCreteInfo.CreteDetail, creteDetails.count > 0 {
            
            let aboutCreteDetailController = AboutCreteDetailController()
            aboutCreteDetailController.aboutCreteInfo = aboutCreteInfo
            self.navigationController?.pushViewController(aboutCreteDetailController, animated: true)
            
        } else {
            let aboutCreteDescriptionController = AboutCreteDescriptionController()
            aboutCreteDescriptionController.aboutCrete = aboutCreteInfo.AboutCrete
            
            self.navigationController?.pushViewController(aboutCreteDescriptionController, animated: true)
        }
        
    }
    
}
