//
//  GeneralRegisterController.swift
//  HotelCrete
//
//  Created by John Nik on 26/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import OneSignal

class GeneralRegisterController: RegisterController {
    
    var hotelMenuController: HotelMenuController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skipButton.isHidden = true
        lineView.isHidden = true
        navigationController?.isNavigationBarHidden = false
        
        let closeImage = UIImage(named: AssetName.close.rawValue)
        let closeButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(handleDismiss))
        
        navigationItem.title = "Register".localized()
        navigationItem.leftBarButtonItem = closeButton
    }
    
    @objc fileprivate func handleDismiss() {
        
        dismiss(animated: true, completion: nil)
    }
    
    override func handleRegister() {
        guard ReachabilityManager.shared.internetIsUp else {
            self.showPMAlertOkay(title: "Internet Error", message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        
        if !checkInvalid() {
            return
        }
        
        guard let surname = surnameTextField.text,
            let name = lastnameTextField.text,
            let checkIn = checkinDateView.dateLabel.text,
            let checkOut = checkoutDateView.dateLabel.text else { return }
        
        let code = UserDefaults.standard.getHotelCode()
        let email = emailTextField.text
        
        let onesignalStatus: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        
        var token = ""
        if let userId = onesignalStatus.subscriptionStatus.userId {
            token = userId
        }
        
        print("toekn, ", token)
        
        let registerUser = Hotel.RegisterUser(surname: surname, name: name, code: code, email: email, checkIn: checkIn, checkOut: checkOut, token: token)
        
        APIService.sharedInstance.handleRegisterUser(registerUser) { (result: Hotel.ResultRegisterUser) in
            switch result {
            case .failure( _):
                self.showErrorMessage(title: "Fail", message: AlertMessages.somethingWentWrong.rawValue)
            case .success(let response):
                
                if let id = response.id {
                    UserDefaults.standard.setUserId(id)
                    
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: {
                            self.hotelMenuController?.handleGoingToQuesstionnaireController()
                        })
                    }
                    
                } else {
                    self.showErrorMessage(title: "Register Fail", message: AlertMessages.invalidRegisterUser.rawValue)
                }
            }
        }
    }
    
}
