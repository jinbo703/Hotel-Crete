//
//  GuideCreteDataAreaDirectionController.swift
//  HotelCrete
//
//  Created by John Nik on 26/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class GuideCreteDataAreaDirectionController: DescriptionController {
    
    var guideCreteDataAreaListController: GuideCreteDataAreaListController?
    
    var guideCreteDatas: [Crete.GuideDataDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(GuideCreteDataAreaDirectionCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    
    func didSelectSegment(_ index: Int) {
        
        if index == 0 {
            
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guideCreteDatas.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GuideCreteDataAreaDirectionCell
        cell.directionController = self
        cell.guideCreteData = guideCreteDatas[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height: CGFloat = INTRODUCTION_IMAGE_HEIGHT + 50
        if let detail = guideCreteDataAreaListController?.getLocalizedString(from: guideCreteDatas[indexPath.item], type: .description) {
            let estimatedHeight = GlobalFunction.estimateFrameForText(text: detail.htmlToString, width: width - 40, font: 15.0).height
            return CGSize(width: width, height: height + estimatedHeight)
        }
        
        return CGSize(width: width, height: height)
    }
    
}

