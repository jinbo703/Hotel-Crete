//
//  CreteExtraDetailController.swift
//  HotelCrete
//
//  Created by John Nik on 24/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import CoreLocation

class CreteExtraDetailController: DescriptionController {
    
    var creteExtraId: Int? {
        
        didSet {
            
            guard let creteExtraId = creteExtraId else { return }
            self.fetchData(creteExtraId: creteExtraId)
            
        }
    }
    
    var creteExtraDetails: [Crete.CreteExtraDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(CreteExtraDetailCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func fetchData(creteExtraId: Int) {
        
        guard ReachabilityManager.shared.internetIsUp else {
            self.showPMAlertOkay(title: "Internet Error", message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        let hotelid = UserDefaults.standard.getHotelId()
        let guideShopping = Crete.CreteExtraId(id: creteExtraId, hotelid: hotelid)
        
        let request = Crete.RequestCreteExtraDetail(GuideShopping: guideShopping)
        
        APIService.sharedInstance.handleGetCreteExtraDetail(request) { (result: Crete.ResultCreteExtraDetail) in
            
            switch result {
            case .failure(_):
                self.showErrorMessage(title: "Server Error", message: AlertMessages.somethingWentWrong.rawValue)
            case .success(let response):
                if let creteExtraDetails = response.result {
                    self.setupCreteExtraDetails(creteExtraDetails)
                }
            }
            
        }
    }
    
    func setupCreteExtraDetails(_ creteExtraDetails: [Crete.GuideShopping]) {
        
        for creteExtraDetail in creteExtraDetails {
            
            if let detail = creteExtraDetail.GuideShopping {
                self.creteExtraDetails.append(detail)
            }
            
        }
        
        self.creteExtraDetails = getCreteExtraDetailsNearbyUser(from: self.creteExtraDetails)
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return creteExtraDetails.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CreteExtraDetailCell
        
        cell.creteExtraDetail = creteExtraDetails[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let creteExtraDetail = creteExtraDetails[indexPath.item]
        
        let creteExtraDetailGuideController = CreteExtraDetailGuideController(collectionViewLayout: UICollectionViewFlowLayout())
        creteExtraDetailGuideController.creteExtraDetails = [creteExtraDetail]
        creteExtraDetailGuideController.navigationItem.title = getLocalizedTitle(from: creteExtraDetail)
        
        navigationController?.pushViewController(creteExtraDetailGuideController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func getLocalizedTitle(from detail: Crete.CreteExtraDetail) -> String? {
        var title: String?
        
        if currentLanguage() == DisplayName.england.rawValue {
            title = detail.title
        } else if currentLanguage() == DisplayName.france.rawValue {
            title = detail.title_french
        } else if currentLanguage() == DisplayName.germany.rawValue {
            title = detail.title_german
        } else if currentLanguage() == DisplayName.italy.rawValue {
            title = detail.title_italian
        } else {
            title = detail.title_russian
        }
        
        return title
    }
}

extension CreteExtraDetailController {
    
    fileprivate func getCreteExtraDetailsNearbyUser(from creteExtraDetails: [Crete.CreteExtraDetail]) -> [Crete.CreteExtraDetail] {
        
        
        let currentLocationCoordinate = CLLocationCoordinate2DMake(35.331690, 24.030762)
        var currentLocation = CLLocation(latitude: currentLocationCoordinate.latitude, longitude: currentLocationCoordinate.longitude)
        if let usersLocation = LocationManager.sharedInstance.userLocation {
            currentLocation = usersLocation
        }

        return creteExtraDetails.sorted { $0.distance(to: currentLocation) < $1.distance(to: currentLocation) }
        
        return creteExtraDetails
    }
    
}
