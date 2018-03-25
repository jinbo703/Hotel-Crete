//
//  CreteMenuController.swift
//  HotelCrete
//
//  Created by John Nik on 18/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import SVProgressHUD

class CreteMenuController: UICollectionViewController {
    
    let cellId = "cellId"
    
    
    var creteExtraInfos: [Crete.CreteExtraInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        fetchData()
    }
    
    func fetchData() {
        
        guard ReachabilityManager.shared.internetIsUp else {
            fetchTempData()
            self.showPMAlertOkay(title: "Internet Error", message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        
        let hotelId = Crete.HotelId(hotelid: UserDefaults.standard.getHotelId())
        
        APIService.sharedInstance.handleGetCreteExtra(hotelId) { (result: Crete.ResultCreteExtra) in
            switch result {
            case .failure(_):
                self.fetchTempData()
                self.showErrorMessage(title: "Server Error", message: AlertMessages.somethingWentWrong.rawValue)
            case .success(let response):
                if let creteExtras = response.result {
                    self.setupCreteExtraInfos(creteExtras)
                }
            }
        }
        
    }
    
    func setupCreteExtraInfos(_ creteExtras: [Crete.CreteExtra]) {
        
        let aboutCreateExtraInfo = Crete.CreteExtraInfo(id: nil, title: "About Crete".localized(), image: "aboutCrete.jpg", created_date: nil, title_greek: nil, title_french: nil, title_german: nil, title_italian: nil, title_russian: nil)
        let guideCreateExtraInfo = Crete.CreteExtraInfo(id: nil, title: "Guide To Crete".localized(), image: "guideToCrete.jpg", created_date: nil, title_greek: nil, title_french: nil, title_german: nil, title_italian: nil, title_russian: nil)
        
        creteExtraInfos.append(aboutCreateExtraInfo)
        creteExtraInfos.append(guideCreateExtraInfo)
        
        for creteExtra in creteExtras {
            
            let tempCreteExtraInfo = creteExtra.CreteExtra
            
            var title: String?
            
            if currentLanguage() == DisplayName.england.rawValue {
                title = tempCreteExtraInfo?.title
            } else if currentLanguage() == DisplayName.france.rawValue {
                title = tempCreteExtraInfo?.title_french
            } else if currentLanguage() == DisplayName.germany.rawValue {
                title = tempCreteExtraInfo?.title_german
            } else if currentLanguage() == DisplayName.italy.rawValue {
                title = tempCreteExtraInfo?.title_italian
            } else {
                title = tempCreteExtraInfo?.title_russian
            }
            
            let newCreteExtra = Crete.CreteExtraInfo(id: tempCreteExtraInfo?.id, title: title, image: tempCreteExtraInfo?.image, created_date: tempCreteExtraInfo?.created_date, title_greek: tempCreteExtraInfo?.title_greek, title_french: nil, title_german: nil, title_italian: nil, title_russian: nil)
            
            
            self.creteExtraInfos.append(newCreteExtra)
            
        }
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
        
    }
    
    func fetchTempData() {
        
        let createExtraInfo1 = Crete.CreteExtraInfo(id: nil, title: "About Crete".localized(), image: "aboutCrete.jpg", created_date: nil, title_greek: nil, title_french: nil, title_german: nil, title_italian: nil, title_russian: nil)
        let createExtraInfo2 = Crete.CreteExtraInfo(id: nil, title: "Guide To Crete".localized(), image: "guideToCrete.jpg", created_date: nil, title_greek: nil, title_french: nil, title_german: nil, title_italian: nil, title_russian: nil)
        let createExtraInfo3 = Crete.CreteExtraInfo(id: nil, title: "Shopping".localized(), image: "Untitled-4.jpg", created_date: nil, title_greek: nil, title_french: nil, title_german: nil, title_italian: nil, title_russian: nil)
        let createExtraInfo4 = Crete.CreteExtraInfo(id: nil, title: "Dining".localized(), image: "Untitled-9.jpg", created_date: nil, title_greek: nil, title_french: nil, title_german: nil, title_italian: nil, title_russian: nil)
        let createExtraInfo5 = Crete.CreteExtraInfo(id: nil, title: "Entertaining".localized(), image: "Untitled-6.jpg", created_date: nil, title_greek: nil, title_french: nil, title_german: nil, title_italian: nil, title_russian: nil)
        let createExtraInfo6 = Crete.CreteExtraInfo(id: nil, title: "Activities".localized(), image: "Untitled-7.jpg", created_date: nil, title_greek: nil, title_french: nil, title_german: nil, title_italian: nil, title_russian: nil)
        let createExtraInfo7 = Crete.CreteExtraInfo(id: nil, title: "Rentals".localized(), image: "Untitled-8.jpg", created_date: nil, title_greek: nil, title_french: nil, title_german: nil, title_italian: nil, title_russian: nil)
        let createExtraInfo8 = Crete.CreteExtraInfo(id: nil, title: "Services".localized(), image: "Untitled-3.jpg", created_date: nil, title_greek: nil, title_french: nil, title_german: nil, title_italian: nil, title_russian: nil)
        creteExtraInfos.append(createExtraInfo1)
        creteExtraInfos.append(createExtraInfo2)
        creteExtraInfos.append(createExtraInfo3)
        creteExtraInfos.append(createExtraInfo4)
        creteExtraInfos.append(createExtraInfo5)
        creteExtraInfos.append(createExtraInfo6)
        creteExtraInfos.append(createExtraInfo7)
        creteExtraInfos.append(createExtraInfo8)

        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return creteExtraInfos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CreteMenuCell
        
        cell.creteExtraInfo = creteExtraInfos[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let creteExtraInfo = creteExtraInfos[indexPath.row]
        
        if indexPath.item == 0 {
            
            let aboutCreteMenuController = AboutCreteMenuController(collectionViewLayout: UICollectionViewFlowLayout())
            aboutCreteMenuController.navigationItem.title = creteExtraInfo.title
             self.navigationController?.pushViewController(aboutCreteMenuController, animated: true)
            
        } else if indexPath.item == 1 {
            
            let guideCreteMenuController = GuideCreteMenuController(collectionViewLayout: UICollectionViewFlowLayout())
            guideCreteMenuController.navigationItem.title = creteExtraInfo.title
            self.navigationController?.pushViewController(guideCreteMenuController, animated: true)
            
        } else {
            
            guard let idString = creteExtraInfo.id, let id = Int(idString) else { return }
            
            let creteExtraDetailController = CreteExtraDetailController(collectionViewLayout: UICollectionViewFlowLayout())
            creteExtraDetailController.creteExtraId = id
            creteExtraDetailController.navigationItem.title = creteExtraInfo.title
            self.navigationController?.pushViewController(creteExtraDetailController, animated: true)
        }
        
    }
    
    
}

extension CreteMenuController {
    func getLocalizedString(from detail: Crete.CreteExtraInfo) -> String? {
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

extension CreteMenuController {
    
    func showErrorMessage(title: String, message: String) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.showPMAlertOkay(title: title, message: message)
        }
    }
}

extension CreteMenuController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: GAP100 * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension CreteMenuController {
    
    @objc fileprivate func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
}

extension CreteMenuController {
    
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
        
        collectionView?.register(CreteMenuCell.self, forCellWithReuseIdentifier: cellId)
    }
}
