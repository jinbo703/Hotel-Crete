//
//  DetailController.swift
//  HotelCrete
//
//  Created by John Nik on 24/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class AccommodationDetailController: DescriptionController {
    
    var accommodationDetails: [HotelMenu] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(AccommodationDetailCell.self, forCellWithReuseIdentifier: cellId)
        
        if accommodationDetails.count > 0 {
            navigationItem.title = accommodationDetails[0].title
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accommodationDetails.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AccommodationDetailCell
        cell.accommodationDetailController = self
        cell.detail = accommodationDetails[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height: CGFloat = GAP100 * 2
        if let detail = accommodationDetails[indexPath.item].description {
            let estimatedHeight = GlobalFunction.estimateFrameForText(text: detail.htmlToString, width: width - 40, font: 15.0).height
            return CGSize(width: width, height: height + estimatedHeight)
        }
        
        
        return CGSize(width: width, height: height)
    }
}
