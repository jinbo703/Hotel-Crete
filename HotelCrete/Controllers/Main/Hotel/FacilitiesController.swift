//
//  FacilitiesController.swift
//  HotelCrete
//
//  Created by John Nik on 18/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class FacilitiesController: HotelMenuController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func fetchHotelMenus() {
        
        guard ReachabilityManager.shared.internetIsUp else {
            fetchTempData()
            return
        }
        
        let hotelId = UserDefaults.standard.getHotelId()
        
        let tempFacilitie = Hotel.TempFacilitie(id: hotelId, category: nil)
        let request = Hotel.FacilitieRequest(Facilitie: tempFacilitie)
        
        APIService.sharedInstance.handleGetHotelFacilitieList(request) { (result: Hotel.ResultHotelFacilitie) in
            
            switch result {
            case .failure(_):
                self.fetchTempData()
            case .success(let response):
                if let facilitieList = response.result {
                    self.setFacilities(facilitieList)
                }
            }
            
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let hotelMenu = hotelMenus[indexPath.item]
        if let category = hotelMenu.description {
            let detailController = FacilitieDetailController(collectionViewLayout: UICollectionViewFlowLayout())
            detailController.category = category
            detailController.navigationTitle = hotelMenu.title
            self.navigationController?.pushViewController(detailController, animated: true)
        }
        
    }
    
    fileprivate func setFacilities(_ facilities: [Hotel.Facilitie]) {
        
        for facilitie in facilities {
            
            var title: String?
            
            let tempFacilitie = facilitie.Facilitie
            
            if currentLanguage() == DisplayName.england.rawValue {
                title = tempFacilitie?.category
            } else if currentLanguage() == DisplayName.france.rawValue {
                title = tempFacilitie?.category_french
            } else if currentLanguage() == DisplayName.germany.rawValue {
                title = tempFacilitie?.category_german
            } else if currentLanguage() == DisplayName.italy.rawValue {
                title = tempFacilitie?.category_italian
            } else {
                title = tempFacilitie?.category_russian
                
            }
            
            let image = tempFacilitie?.image
            let category = tempFacilitie?.category
            
            let menu = HotelMenu(backgroundImageUrl: image, title: title, description: category)
            self.hotelMenus.append(menu)
        }
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
        
    }
    
    fileprivate func fetchTempData() {
        let menu1 = HotelMenu(backgroundImageUrl: "Untitled-3.jpg", title: "RESTAURANTS", description: nil)
        let menu2 = HotelMenu(backgroundImageUrl: "Untitled-2.jpg", title: "BARS", description: nil)
        let menu3 = HotelMenu(backgroundImageUrl: "Untitled-4.jpg", title: "SWIMMING POOLS", description: nil)
        let menu4 = HotelMenu(backgroundImageUrl: "Untitled-9.jpg", title: "HOTEL BEACH", description: nil)
        let menu5 = HotelMenu(backgroundImageUrl: "Untitled-6.jpg", title: "SPA WELLNESS & FITNESS", description: nil)
        let menu6 = HotelMenu(backgroundImageUrl: "Untitled-7.jpg", title: "CONFERENCE ROOM", description: nil)
        let menu7 = HotelMenu(backgroundImageUrl: "Untitled-8.jpg", title: "ANIMATION", description: nil)
        let menu8 = HotelMenu(backgroundImageUrl: "Untitled-4.jpg", title: "MINI CLUB", description: nil)
        let menu9 = HotelMenu(backgroundImageUrl: "Untitled-2.jpg", title: "GYM & FITNESS ROOM", description: nil)
        let menu10 = HotelMenu(backgroundImageUrl: "Untitled-3.jpg", title: "SPORT FACILITIES", description: nil)
        let menu11 = HotelMenu(backgroundImageUrl: "Untitled-9.jpg", title: "HOTEL STORES", description: nil)
        hotelMenus.append(menu1)
        hotelMenus.append(menu2)
        hotelMenus.append(menu3)
        hotelMenus.append(menu4)
        hotelMenus.append(menu5)
        hotelMenus.append(menu6)
        hotelMenus.append(menu7)
        hotelMenus.append(menu8)
        hotelMenus.append(menu9)
        hotelMenus.append(menu10)
        hotelMenus.append(menu11)
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
        
    }
}
