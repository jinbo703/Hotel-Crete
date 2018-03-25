//
//  HotelMenuController.swift
//  HotelCrete
//
//  Created by John Nik on 18/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import SVProgressHUD

class HotelMenuController: UICollectionViewController {
    
    let cellId = "cellId"
    
    var hotelMenus: [HotelMenu] = []
    
    var hotelInfo: Hotel.HotelInfo? {
        
        didSet {
            fetchHotelAbout()
        }
    }
    
    var hotelAbouts: [Hotel.HotelAbout] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        fetchHotelMenus()
    }
    
    func fetchHotelAbout() {
        
        guard let hotelInfo = hotelInfo else { return }
        
        var hotelName: String?
        
        if currentLanguage() == DisplayName.england.rawValue {
            hotelName = hotelInfo.hotelname
        } else if currentLanguage() == DisplayName.france.rawValue {
            hotelName = hotelInfo.hotelname_french
        } else if currentLanguage() == DisplayName.germany.rawValue {
            hotelName = hotelInfo.hotelname_german
        } else if currentLanguage() == DisplayName.italy.rawValue {
            hotelName = hotelInfo.hotelname_italian
        } else {
            hotelName = hotelInfo.hotelname_russian
        }
        
        navigationItem.title = hotelName
        
        guard ReachabilityManager.shared.internetIsUp else {
            self.showPMAlertOkay(title: "Internet Error", message: AlertMessages.failedInternetTitle.rawValue)
            fetchDefaultHotelMenus()
            return
        }
        
        let addHotel = Hotel.AddHotel(AddHotel: hotelInfo)
        
        APIService.sharedInstance.handleGetHotelAbout(addHotel) { (result: Hotel.ResultHotelAbout) in
            
            switch result {
            case .failure(_):
                self.showErrorMessage(title: "Server Error", message: AlertMessages.somethingWentWrong.rawValue)
            case .success(let response):
                if let hotelAbouts = response.result {
                    self.fetchDefaultHotelMenus()
                    self.hotelAbouts = hotelAbouts
                    self.resetHotelMenu()
                }
            }
            
        }
    }
    
    func resetHotelMenu() {
        if hotelAbouts.count > 0 {
            let hotelAbout = self.hotelAbouts[0]
            
            var indexPaths: [IndexPath] = []
            
            if let imageUrl = hotelAbout.About?.image {
                self.hotelMenus[0].backgroundImageUrl = imageUrl
                indexPaths.append(IndexPath(item: 0, section: 0))
            }
            
            var serviceImage = "defaultServiceBackground.jpg"
            var facilityImage = "defaultFacilitiesBackground.jpg"
            var accommodationImage = "defaultAccomodationBackground.jpg"
            
            if let serviceImageUrl = hotelInfo?.service_image, serviceImageUrl.count > 0 {
                serviceImage = serviceImageUrl
            }
            
            if let facilityImageUrl = hotelInfo?.facilitie_image, facilityImageUrl.count > 0 {
                facilityImage = facilityImageUrl
            }
            
            if let accommodationImageUrl = hotelInfo?.accommodation_image, accommodationImageUrl.count > 0 {
                accommodationImage = accommodationImageUrl
            }
            
            self.hotelMenus[1].backgroundImageUrl = serviceImage
            self.hotelMenus[2].backgroundImageUrl = facilityImage
            self.hotelMenus[3].backgroundImageUrl = accommodationImage
            
            indexPaths.append(IndexPath(item: 1, section: 0))
            indexPaths.append(IndexPath(item: 2, section: 0))
            indexPaths.append(IndexPath(item: 3, section: 0))
            DispatchQueue.main.async {
                self.collectionView?.reloadItems(at: indexPaths)
            }
        }
    }
    
    fileprivate func fetchDefaultHotelMenus() {
        let menu1 = HotelMenu(backgroundImageUrl: "", title: "", description: nil)
        let menu2 = HotelMenu(backgroundImageUrl: "", title: "Services".localized(), description: nil)
        let menu3 = HotelMenu(backgroundImageUrl: "", title: "Facilities".localized(), description: nil)
        let menu4 = HotelMenu(backgroundImageUrl: "", title: "Accommodation".localized(), description: nil)
        let menu5 = HotelMenu(backgroundImageUrl: "socialMedia.jpg", title: "Social Media".localized(), description: nil)
        let menu6 = HotelMenu(backgroundImageUrl: "questionnaire.jpg", title: "Questionnaire".localized(), description: nil)
        let menu7 = HotelMenu(backgroundImageUrl: "contactUs.jpg", title: "Contact Us".localized(), description: nil)
        
        hotelMenus.append(menu1)
        hotelMenus.append(menu2)
        hotelMenus.append(menu3)
        hotelMenus.append(menu4)
        hotelMenus.append(menu5)
        hotelMenus.append(menu6)
        hotelMenus.append(menu7)
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    func fetchHotelMenus() {
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotelMenus.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HotelMenuCell
        
        cell.hotelMenu = hotelMenus[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let title = hotelMenus[indexPath.row].title
        
        var rootController: UICollectionViewController?
        var rootGeneralController: UIViewController?
        
        if indexPath.item == 0 {
            
            let introductionController = HotelIntroController(collectionViewLayout: UICollectionViewFlowLayout())
            introductionController.hotelAbouts = self.hotelAbouts
            self.navigationController?.pushViewController(introductionController, animated: true)
            return
        } else if indexPath.item == 1 {
            rootGeneralController = ServicesController()
            
        } else if indexPath.item == 2 {
            rootController = FacilitiesController(collectionViewLayout: UICollectionViewFlowLayout())
            
        } else if indexPath.item == 3 {
            rootController = AccommodationController(collectionViewLayout: UICollectionViewFlowLayout())
            
        } else if indexPath.item == 4 {
            rootGeneralController = SocialMediaController()
            
        } else if indexPath.item == 6 {
            rootGeneralController = ContactController()
        } else {
            
            if let _ = UserDefaults.standard.getUserId() {
                rootGeneralController = QuestionnaireController()
            } else {
                
                self.showPMAlertDefault("Sorry, you should register to sumbit questionnaires first".localized(), message: "Do you want to register now?".localized(), action: {
                    
                    let generalRegisterController = GeneralRegisterController()
                    generalRegisterController.hotelMenuController = self
                    let navController = UINavigationController(rootViewController: generalRegisterController)
                    
                    self.present(navController, animated: true, completion: nil)
                })
            }
        }
        
        if let controller = rootController {
            controller.navigationItem.title = title
            navigationController?.pushViewController(controller, animated: true)
        }
        
        if let controller = rootGeneralController {
            controller.navigationItem.title = title
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func handleGoingToQuesstionnaireController() {
        let questionnaireController = QuestionnaireController()
        navigationController?.pushViewController(questionnaireController, animated: true)
    }
}

extension HotelMenuController {
    
    func showErrorMessage(title: String, message: String) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.showPMAlertOkay(title: title, message: message)
        }
    }
}

extension HotelMenuController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: GAP100 * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension HotelMenuController {
    
    @objc fileprivate func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
}

extension HotelMenuController {
    
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
        
        collectionView?.register(HotelMenuCell.self, forCellWithReuseIdentifier: cellId)
    }
}
