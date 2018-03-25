//
//  Alerts.swift
//  InstaChain
//
//  Created by John Nik on 11/17/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import Foundation
import UIKit
//import JHTAlertController
import PMAlertController

typealias AlertActionHandler = (UIAlertAction)->()
typealias AlertPresentCompletion = ()->()


//MARK: handle pmalertcontroller
typealias PMAlertActionHandler = () -> ()

extension UIViewController {
    
    func showPMAlertDefault(_ title: String, message: String, firstTitle: String? = "Ok".localized(), secondeTitle: String? = "Cancel".localized(), action: @escaping PMAlertActionHandler) {
        let alert = PMAlertController(title: title.localized(), description: message.localized(), image: nil, style: .alert)
        
        let yesAction = PMAlertAction(title: firstTitle, style: .default, action: action)
        let noAction = PMAlertAction(title: secondeTitle, style: .cancel)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showPMAlertOkay(title: String, message: String) {
        let alert = PMAlertController(title: title.localized(), description: message.localized(), image: nil, style: .alert)
        
        let noAction = PMAlertAction(title: "Ok".localized(), style: .cancel)
        
        
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showPMAlertOkayAction(title: String, message: String, action: @escaping PMAlertActionHandler) {
        let alert = PMAlertController(title: title.localized(), description: message.localized(), image: nil, style: .alert)
        
        let noAction = PMAlertAction(title: "Ok".localized(), style: .cancel, action: action)
        
        
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    }
}


//
////MARK: handle jhtalertaction
//typealias JHTAlertActionHandler = ((JHTAlertAction) -> Void)!
//extension UIViewController {
//
//    func showJHTAlerttOkayWithIcon(message: String) {
//
//        let alertController = JHTAlertController(title: "Wenyeji", message: message, preferredStyle: .alert)
//        alertController.titleImage = UIImage(named: AssetName.alertIcon.rawValue)
//        alertController.titleViewBackgroundColor = .white
//        alertController.titleTextColor = .black
//        alertController.alertBackgroundColor = .white
//        alertController.messageFont = .systemFont(ofSize: 18)
//        alertController.messageTextColor = .black
//        alertController.setAllButtonBackgroundColors(to: .white)
//        alertController.dividerColor = .black
//        alertController.setButtonTextColorFor(.cancel, to: .black)
//        alertController.hasRoundedCorners = true
//
//        let cancelAction = JHTAlertAction(title: "OK", style: .cancel,  handler: nil)
//
//        alertController.addAction(cancelAction)
//
//        present(alertController, animated: true, completion: nil)
//
//    }
//
//    func showJHTAlerttOkayActionWithIcon(message: String, action: JHTAlertActionHandler) {
//
//        let alertController = JHTAlertController(title: "", message: message, preferredStyle: .alert)
//        alertController.titleImage = UIImage(named: AssetName.alertIcon.rawValue)
//        alertController.titleViewBackgroundColor = .white
//        alertController.titleTextColor = .black
//        alertController.alertBackgroundColor = .white
//        alertController.messageFont = .systemFont(ofSize: 18)
//        alertController.messageTextColor = .black
//        alertController.setAllButtonBackgroundColors(to: .white)
//        alertController.dividerColor = .black
//        alertController.setButtonTextColorFor(.cancel, to: .black)
//        alertController.hasRoundedCorners = true
//
//        let cancelAction = JHTAlertAction(title: "OK", style: .cancel,  handler: action)
//
//        alertController.addAction(cancelAction)
//
//        present(alertController, animated: true, completion: nil)
//
//    }
//
//    func showJHTAlertDefaultWithIcon(message: String, firstActionTitle: String, secondActionTitle: String, action: JHTAlertActionHandler) {
//
//        let alertController = JHTAlertController(title: "", message: message, preferredStyle: .alert)
//        alertController.titleImage = UIImage(named: AssetName.alertIcon.rawValue)
//        alertController.titleViewBackgroundColor = .white
//        alertController.titleTextColor = .black
//        alertController.alertBackgroundColor = .white
//        alertController.messageFont = .systemFont(ofSize: 18)
//        alertController.messageTextColor = .black
//        alertController.setAllButtonBackgroundColors(to: .white)
//        alertController.dividerColor = .black
//        alertController.setButtonTextColorFor(.default, to: StyleGuideManager.mainLightBlueBackgroundColor)
//        alertController.setButtonTextColorFor(.cancel, to: .black)
//        alertController.hasRoundedCorners = true
//
//        let cancelAction = JHTAlertAction(title: firstActionTitle, style: .cancel,  handler: nil)
//        let okAction = JHTAlertAction(title: secondActionTitle, style: .default, handler: action)
//
//        alertController.addAction(cancelAction)
//        alertController.addAction(okAction)
//
//        present(alertController, animated: true, completion: nil)
//
//    }
//
//    func showJHTAlertDefault(title: String, message: String, firstActionTitle: String, secondActionTitle: String, action: JHTAlertActionHandler) {
//
//        let alertController = JHTAlertController(title: title, message: message, preferredStyle: .alert)
//        alertController.titleViewBackgroundColor = .white
//        alertController.titleTextColor = .black
//        alertController.alertBackgroundColor = .white
//        alertController.messageFont = .systemFont(ofSize: 18)
//        alertController.messageTextColor = .black
//        alertController.setAllButtonBackgroundColors(to: .white)
//        alertController.dividerColor = .black
//        alertController.setButtonTextColorFor(.default, to: .red)
//        alertController.setButtonTextColorFor(.cancel, to: .black)
//        alertController.hasRoundedCorners = true
//
//        let cancelAction = JHTAlertAction(title: firstActionTitle, style: .cancel,  handler: nil)
//        let okAction = JHTAlertAction(title: secondActionTitle, style: .default, handler: action)
//
//        alertController.addAction(cancelAction)
//        alertController.addAction(okAction)
//
//        present(alertController, animated: true, completion: nil)
//
//    }
//}

extension UIViewController {
    
    func showErrorAlert(_ title:String? = nil, message:String, action:(AlertActionHandler)? = nil, completion:AlertPresentCompletion? = nil){
        let alert = UIAlertController(title: title, message: message.localized(), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized(), style: .default, handler: action)
        alert.addAction(okAction)
        present(alert, animated: true, completion: completion)
    }
    
    func showErrorAlertWith(_ title:String, message: String, action:(AlertActionHandler)? = nil, completion:AlertPresentCompletion? = nil){
        let alert = UIAlertController(title: title, message: message.localized(), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized(), style: .default, handler: action)
        alert.addAction(okAction)
        present(alert, animated: true, completion: completion)
    }
    
    func showErrorAlertWithOKCancel(_ title:String? = nil, message:String, action:(AlertActionHandler)? = nil, completion:AlertPresentCompletion? = nil){
        let alert = UIAlertController(title: title, message: message.localized(), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized(), style: .default, handler: action)
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .destructive, handler: nil)
        alert.addAction(cancelAction)
        
        
        
        present(alert, animated: true, completion: completion)
//        alert.view.tintColor = UIColor.green
    }
    
    func showErrorAlertWithAgree(_ title:String? = nil, message:String, action:(AlertActionHandler)? = nil, disagreeAction:(AlertActionHandler)? = nil, completion:AlertPresentCompletion? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Agree", style: .default, handler: action)
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Disagree", style: .destructive, handler: nil)
        alert.addAction(cancelAction)
        alert.view.frame = UIScreen.main.bounds
        
        okAction.setValue(UIColor.red, forKey: "titleTextColor")
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        present(alert, animated: true, completion: completion)
    }
    
    func showActionSheetWith(_ title:String? = nil, message: String, galleryTitle: String, galleryAction:(AlertActionHandler)? = nil, cameraTitle: String, cameraAction:(AlertActionHandler)? = nil, completion:AlertPresentCompletion? = nil) {
        
        let alert = UIAlertController(title: title, message: message.localized(), preferredStyle: .actionSheet)
        let galleryAction = UIAlertAction(title: galleryTitle.localized(), style: .default, handler: galleryAction)
        let cameraAction = UIAlertAction(title: cameraTitle.localized(), style: .default, handler: cameraAction)
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .destructive, handler: nil)
        alert.addAction(galleryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: completion)
        alert.view.tintColor = StyleGuideManager.defaultBackgroundColor
    }
    
    func showMultiActionSheetWith(_ title:String? = nil, message: String, galleryActionTitle: String, cameraActionTitle: String, otherActionTitle: String, galleryAction:(AlertActionHandler)? = nil, cameraAction:(AlertActionHandler)? = nil, otherAction:(AlertActionHandler)? = nil, completion:AlertPresentCompletion? = nil) {
        
        let alert = UIAlertController(title: title, message: message.localized(), preferredStyle: .actionSheet)
        let galleryAction = UIAlertAction(title: galleryActionTitle.localized(), style: .default, handler: galleryAction)
        let cameraAction = UIAlertAction(title: cameraActionTitle.localized(), style: .default, handler: cameraAction)
        let otherAction = UIAlertAction(title: otherActionTitle.localized(), style: .default, handler: otherAction)
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .destructive, handler: nil)
        alert.addAction(galleryAction)
        alert.addAction(cameraAction)
        alert.addAction(otherAction)
        alert.addAction(cancelAction)
        
        if let popOverAlert = alert.popoverPresentationController {
            popOverAlert.sourceRect = CGRect(x: DEVICE_WIDTH - 60, y: DEVICE_HEIGHT - 50, width: 0, height: 0)
            popOverAlert.sourceView = self.view
        }
        
        present(alert, animated: true, completion: completion)
        alert.view.tintColor = StyleGuideManager.mainLightBlueBackgroundColor
    }
}

