//
//  AboutCreteGastronomyDescriptionController.swift
//  HotelCrete
//
//  Created by John Nik on 24/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class AboutCreteGastronomyDescriptionController: AboutCreteDescriptionController {
    var gastronomy: Crete.Gastronomy?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupAboutCrete() {
        
        guard let gastronomy = gastronomy else { return }
        
        
        navigationItem.title = getLocalizedString(from: gastronomy, type: .title)
        
        detailTextView.text = getLocalizedString(from: gastronomy, type: .description)?.htmlToString
        detailTextView.isScrollEnabled = false
        
    }
}

extension AboutCreteGastronomyDescriptionController {
    func getLocalizedString(from detail: Crete.Gastronomy, type: StringType) -> String? {
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
