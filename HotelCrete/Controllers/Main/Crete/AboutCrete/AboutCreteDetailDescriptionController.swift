//
//  AboutCreteDetailDescriptionController.swift
//  HotelCrete
//
//  Created by John Nik on 24/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class AboutCreteDetailDescriptionController: AboutCreteDescriptionController {
    
    var creteDetail: Crete.CreteDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupAboutCrete() {
        
        guard let creteDetail = creteDetail else { return }
        
        
        navigationItem.title = getLocalizedString(from: creteDetail, type: .title)
        
        detailTextView.text = getLocalizedString(from: creteDetail, type: .description)?.htmlToString
        detailTextView.isScrollEnabled = false
        
    }
    
}

extension AboutCreteDetailDescriptionController {
    func getLocalizedString(from detail: Crete.CreteDetail, type: StringType) -> String? {
        var string: String?
        
        if currentLanguage() == DisplayName.england.rawValue {
            if type == .title {
                string = detail.title
            } else {
                string = detail.description
            }
            
        } else if currentLanguage() == DisplayName.france.rawValue {
            if type == .title {
                string = detail.title_french
            } else {
                string = detail.description_french
            }
            
        } else if currentLanguage() == DisplayName.germany.rawValue {
            if type == .title {
                string = detail.title_german
            } else {
                string = detail.description_german
            }
            
        } else if currentLanguage() == DisplayName.italy.rawValue {
            if type == .title {
                string = detail.title_italian
            } else {
                string = detail.description_italian
            }
            
        } else {
            if type == .title {
                string = detail.title_russian
            } else {
                string = detail.description_russian
            }
            
        }
        
        return string
    }
}

