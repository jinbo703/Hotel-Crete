//
//  IntroductionController.swift
//  HotelCrete
//
//  Created by John Nik on 18/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import ImageSlideshow

class IntroductionController: UICollectionViewController {
    
    
    let cellId = "cellId"
    
    var hotelAbouts: [Hotel.HotelAbout]? {
        
        didSet {
            self.fetchHotelAbouts()
        }
    }
    var introductions: [Introduction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func fetchHotelAbouts() {
        
        guard let hotelAbouts = self.hotelAbouts else { return }
        
        var images: [String] = []
        var detail: String?
        var title: String?
        for hotelAbout in hotelAbouts {
            
            if let imageUrl = hotelAbout.About?.image {
                images.append(imageUrl)
            } else {
                images.append("Untitled-4.jpg")
            }
            detail = hotelAbouts[0].addhotels?.description
            title = hotelAbouts[0].addhotels?.hotelname
        }
        
        if hotelAbouts.count > 0 {
            
            let addHotel = hotelAbouts[0].addhotels
            if currentLanguage() == DisplayName.england.rawValue {
                title = addHotel?.hotelname
                detail = addHotel?.description
            } else if currentLanguage() == DisplayName.france.rawValue {
                title = addHotel?.hotelname_french
                detail = addHotel?.description_french
            } else if currentLanguage() == DisplayName.germany.rawValue {
                title = addHotel?.hotelname_german
                detail = addHotel?.description_german
            } else if currentLanguage() == DisplayName.italy.rawValue {
                title = addHotel?.hotelname_italian
                detail = addHotel?.description_italian
            } else {
                title = addHotel?.hotelname_russian
                detail = addHotel?.description_russian
            }
        }
        
        let introduction = Introduction(images: images, title: title, detail: detail, latitude: nil, longitude: nil)
        navigationItem.title = introduction.title
        introductions.append(introduction)
        collectionView?.reloadData()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return introductions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! IntroductionCell
        cell.introductionController = self
        cell.introduction = introductions[indexPath.item]
        
        return cell
    }
}


extension IntroductionController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        guard let detail = introductions[indexPath.item].detail else {
            return CGSize(width: width, height: 300)
        }
        
        let estimatedHeight = GlobalFunction.estimateFrameForText(text: detail.htmlToString, width: width - 40, font: 19.0).height
        
        let height = estimatedHeight + INTRODUCTION_IMAGE_HEIGHT + 50
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


extension IntroductionController {
    
    @objc fileprivate func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
}

extension IntroductionController {
    
    fileprivate func setupViews() {
        
        setupCollectionView()
        setupNavBar()
    }
    
    private func setupNavBar() {
        
        
        
        let image = UIImage(named: AssetName.back.rawValue)
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleDismiss))
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupCollectionView() {
        collectionView?.backgroundColor = .white
        
        collectionView?.register(IntroductionCell.self, forCellWithReuseIdentifier: cellId)
    }
}
