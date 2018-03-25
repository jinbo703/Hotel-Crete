//
//  AboutCreteDetailController.swift
//  HotelCrete
//
//  Created by John Nik on 24/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class AboutCreteDetailController: SocialMediaController {
    
    var aboutCreteInfo: Crete.AboutCreteInfo?
    
    var creteDetails: [Crete.CreteDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(AboutCreteDetailCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func fetchData() {
        guard let aboutCreteInfo = aboutCreteInfo else { return }
        if let aboutCrete = aboutCreteInfo.AboutCrete {
            if let imageUrl = aboutCrete.background {
                backgroundImageView.image = nil
                self.backgroundImageView.loadSDWebImageWithUrlString(imageUrl)
            }
            
            navigationItem.title = getLocalizedTitle(from: aboutCrete)
        }
        
        if let creteDetails = aboutCreteInfo.CreteDetail {
            self.creteDetails = creteDetails
            
            let height = CGFloat(creteDetails.count) * tableViewCellHeight
            
            
            DispatchQueue.main.async {
                self.tableViewHeightConstraint?.constant = height
                self.tableView.reloadData()
            }
        }
    }
    
    func handleGoingToDetailController(creteDetail: Crete.CreteDetail) {
        let aboutCreteDetailDescriptionController = AboutCreteDetailDescriptionController()
        aboutCreteDetailDescriptionController.creteDetail = creteDetail
        
        self.navigationController?.pushViewController(aboutCreteDetailDescriptionController, animated: true)
    }
    
    func handleWhereToController(creteDetail: Crete.CreteDetail) {
        if let gastronomy = creteDetail.Gastronomy, gastronomy.count > 0 {
            
            let gastronomyController = AboutCreteGastronomyController(collectionViewLayout: UICollectionViewFlowLayout())
            gastronomyController.gastronomies = gastronomy
            gastronomyController.navigationItem.title = getLocalizedString(from: creteDetail)
            
            self.navigationController?.pushViewController(gastronomyController, animated: true)
            
        } else {
            self.handleGoingToDetailController(creteDetail: creteDetail)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let creteDetail = creteDetails[indexPath.row]
        
        self.handleWhereToController(creteDetail: creteDetail)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creteDetails.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AboutCreteDetailCell
        cell.detailController = self
        cell.creteDetail = creteDetails[indexPath.item]
        
        return cell
    }
}

extension AboutCreteDetailController {
    
    func getLocalizedTitle(from detail: Crete.AboutCrete) -> String? {
        var string: String?
        
        if currentLanguage() == DisplayName.england.rawValue {
            string = detail.title
        } else if currentLanguage() == DisplayName.france.rawValue {
            string = detail.title_french
        } else if currentLanguage() == DisplayName.germany.rawValue {
            string = detail.title_german
        } else if currentLanguage() == DisplayName.italy.rawValue {
            string = detail.title_italian
        } else {
            string = detail.title_russian
        }
        
        return string
    }
    
    func getLocalizedString(from detail: Crete.CreteDetail) -> String? {
        var string: String?
        
        if currentLanguage() == DisplayName.england.rawValue {
            string = detail.title
        } else if currentLanguage() == DisplayName.france.rawValue {
            string = detail.title_french
        } else if currentLanguage() == DisplayName.germany.rawValue {
            string = detail.title_german
        } else if currentLanguage() == DisplayName.italy.rawValue {
            string = detail.title_italian
        } else {
            string = detail.title_russian
        }
        
        return string
    }
}
