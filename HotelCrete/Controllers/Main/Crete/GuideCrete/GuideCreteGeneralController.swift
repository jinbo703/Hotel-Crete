//
//  GuideCreteGeneralController.swift
//  HotelCrete
//
//  Created by John Nik on 25/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class GuideCreteGeneralController: HotelMenuController {
    
    var guideCreteInfo: Crete.GuideCreteInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(GuideCreteGeneralCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func fetchHotelMenus() {
        
        if let title = guideCreteInfo?.GuideCrete?.title, title != "Towns/Villages" {
            collectionView?.backgroundColor = .white
            return
        }
        collectionView?.backgroundColor = .black
        let menu1 = HotelMenu(backgroundImageUrl: "east", title: "East Crete", description: nil)
        let menu2 = HotelMenu(backgroundImageUrl: "west", title: "West Crete", description: nil)
        
        hotelMenus.append(menu1)
        hotelMenus.append(menu2)
        
        collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GuideCreteGeneralCell
        
        cell.hotelMenu = hotelMenus[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let guideVillageController = GuideCreteVillageController(collectionViewLayout: UICollectionViewFlowLayout())
        guideVillageController.region = hotelMenus[indexPath.item].title
        
        navigationController?.pushViewController(guideVillageController, animated: true)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: GAP100 * 3)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
}
