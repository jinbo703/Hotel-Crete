//
//  AccommodationController.swift
//  HotelCrete
//
//  Created by John Nik on 18/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class AccommodationController: HotelMenuController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func fetchHotelMenus() {
        guard ReachabilityManager.shared.internetIsUp else {
            fetchTempData()
            return
        }
        
        let hotelId = UserDefaults.standard.getHotelId()
        
        let tempHotelId = Hotel.HotelId(id: hotelId)
        let request = Hotel.AccommodationRequest(Accommodation: tempHotelId)
        
        APIService.sharedInstance.handleGetHotelAccommodation(request) { (result: Hotel.ResultHotelAccommodation) in
            
            switch result {
            case .failure(_):
                self.fetchTempData()
            case .success(let response):
                if let accommodations = response.result {
                    self.setAccommodations(accommodations)
                }
            }
            
        }

    }
    
    fileprivate func setAccommodations(_ accommodations: [Hotel.Accommodation]) {
        
        for accommodation in accommodations {
            
            var title: String?
            var description: String?
            let tempAccommodation = accommodation.Accommodation
            
            if currentLanguage() == DisplayName.england.rawValue {
                title = tempAccommodation?.title
                description = tempAccommodation?.description
            } else if currentLanguage() == DisplayName.france.rawValue {
                title = tempAccommodation?.title_french
                description = tempAccommodation?.description_french
            } else if currentLanguage() == DisplayName.germany.rawValue {
                title = tempAccommodation?.title_german
                description = tempAccommodation?.description_german
            } else if currentLanguage() == DisplayName.italy.rawValue {
                title = tempAccommodation?.title_italian
                description = tempAccommodation?.description_italian
            } else {
                title = tempAccommodation?.title_russian
                description = tempAccommodation?.description_russian
                
            }
            let image = tempAccommodation?.image
            
            let menu = HotelMenu(backgroundImageUrl: image, title: title, description: description)
            self.hotelMenus.append(menu)
        }
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
        
    }
    
    fileprivate func fetchTempData() {
        let menu1 = HotelMenu(backgroundImageUrl: "Untitled-4.jpg", title: "Standard Bungalows", description: nil)
        let menu2 = HotelMenu(backgroundImageUrl: "Untitled-3.jpg", title: "Family Bungalows", description: nil)
        let menu3 = HotelMenu(backgroundImageUrl: "Untitled-4.jpg", title: "VIP Suites", description: nil)
        let menu4 = HotelMenu(backgroundImageUrl: "Untitled-9.jpg", title: "Villas", description: nil)
        hotelMenus.append(menu1)
        hotelMenus.append(menu2)
        hotelMenus.append(menu3)
        hotelMenus.append(menu4)
        collectionView?.reloadData()
    }
    
   
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let hotelMenu = hotelMenus[indexPath.row]
        
        let detailController = AccommodationDetailController(collectionViewLayout: UICollectionViewFlowLayout())
        detailController.accommodationDetails = [hotelMenu]
        navigationController?.pushViewController(detailController, animated: true)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: GAP100 * 2)
    }
}
