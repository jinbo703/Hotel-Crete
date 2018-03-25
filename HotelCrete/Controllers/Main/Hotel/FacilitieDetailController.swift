//
//  FacilitieDetailController.swift
//  HotelCrete
//
//  Created by John Nik on 24/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class FacilitieDetailController: DescriptionController {
    
    var facilitieDetails: [HotelMenu] = []
    
    var category: String? {
        
        didSet {
            guard let category = category else { return }
            
            self.fetchHotelMenus(category: category)
        }
    }
    
    var navigationTitle: String? {
        didSet {
            navigationItem.title = navigationTitle
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(FacilitieDetailCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func fetchHotelMenus(category: String) {
        
        guard ReachabilityManager.shared.internetIsUp else {
            self.showPMAlertOkay(title: "Internet Error", message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        
        let hotelId = UserDefaults.standard.getHotelId()
        
        let tempFacilitie = Hotel.TempFacilitie(id: hotelId, category: category)
        let request = Hotel.FacilitieRequest(Facilitie: tempFacilitie)
        
        APIService.sharedInstance.handleGetHotelFacilitie(request) { (result: Hotel.ResultHotelFacilitie) in
            
            switch result {
            case .failure(_):
                self.showPMAlertOkay(title: "Internet Error", message: AlertMessages.failedInternetTitle.rawValue)
            case .success(let response):
                if let facilitieList = response.result {
                    self.setFacilities(facilitieList)
                }
            }
            
        }
        
    }
    
    func setFacilities(_ facilities: [Hotel.Facilitie]) {
        
        for facilitie in facilities {
            
            var title: String?
            var description: String?
            let tempFacilitie = facilitie.Facilitie
            
            if currentLanguage() == DisplayName.england.rawValue {
                title = tempFacilitie?.category
                description = tempFacilitie?.description
            } else if currentLanguage() == DisplayName.france.rawValue {
                title = tempFacilitie?.category_french
                description = tempFacilitie?.description_french
            } else if currentLanguage() == DisplayName.germany.rawValue {
                title = tempFacilitie?.category_german
                description = tempFacilitie?.description_german
            } else if currentLanguage() == DisplayName.italy.rawValue {
                title = tempFacilitie?.category_italian
                description = tempFacilitie?.description_italian
            } else {
                title = tempFacilitie?.category_russian
                description = tempFacilitie?.description_russian
                
            }
            let image = tempFacilitie?.image
            
            let menu = HotelMenu(backgroundImageUrl: image, title: title, description: description)
            self.facilitieDetails.append(menu)
        }
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return facilitieDetails.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FacilitieDetailCell
        
        cell.detail = facilitieDetails[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height: CGFloat = GAP100 * 2
        if let detail = facilitieDetails[indexPath.item].description, let convertedDetail = detail.htmlToAttributedString(for: 16)?.string {
            let estimatedHeight = GlobalFunction.estimateFrameForText(text: convertedDetail, width: width - 40, font: 17.0).height + 20
            return CGSize(width: width, height: height + estimatedHeight)
        }
        return CGSize(width: width, height: height)
    }
    
}
