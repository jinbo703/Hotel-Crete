//
//  ContactController.swift
//  HotelCrete
//
//  Created by John Nik on 05/03/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import SVProgressHUD

class ContactController: AboutCreteDescriptionController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTextView.dataDetectorTypes = .all
        detailTextView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: StyleGuideManager.mainLightBlueBackgroundColor]
    }
    
    override func setupAboutCrete() {
        
        guard ReachabilityManager.shared.internetIsUp else {
            self.showPMAlertOkay(title: "Internet Error", message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        
        let hotelId = UserDefaults.standard.getHotelId()
        let contact = Hotel.HotelId(id: hotelId)
        let request = Hotel.RequestContact(Contact: contact)
        
        APIService.sharedInstance.handleGetContact(request) { (result: Hotel.ResultContact) in
            
            switch result {
            case .failure(_):
                self.showErrorMessage(title: "Server Error", message: AlertMessages.somethingWentWrong.rawValue)
            case .success(let response):
                if let contact = response.result {
                    
                    DispatchQueue.main.async {
                        if contact.count > 0 {
                            
                            var info: String?
                            let tempContact = contact[0].Contact
                            
                            if currentLanguage() == DisplayName.england.rawValue {
                                info = tempContact?.info
                            } else if currentLanguage() == DisplayName.france.rawValue {
                                info = tempContact?.info_french
                            } else if currentLanguage() == DisplayName.germany.rawValue {
                                info = tempContact?.info_german
                            } else if currentLanguage() == DisplayName.italy.rawValue {
                                info = tempContact?.info_italian
                            } else {
                                info = tempContact?.info_russian
                            }
                            
                            
                            guard let contactInfo = info, let contactInfoAttributedString = contactInfo.htmlToAttributedString(for: 18) else { return }
                            
                            self.detailTextView.attributedText = contactInfoAttributedString
                            self.detailTextView.isScrollEnabled = false
                        }
                        
                    }
                    
                }
            }
            
        }
        
    }
    
    
}

extension ContactController {
    
    func showErrorMessage(title: String, message: String) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.showPMAlertOkay(title: title, message: message)
        }
    }
}
