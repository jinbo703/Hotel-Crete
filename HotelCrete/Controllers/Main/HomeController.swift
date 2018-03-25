//
//  HomeController.swift
//  HotelCrete
//
//  Created by John Nik on 14/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import SDWebImage
import Localize_Swift

var appDelegate = UIApplication.shared.delegate as! AppDelegate

class HomeController: UIViewController {
    
    var hotelInfo: Hotel.HotelInfo?
    
    let backgroundImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var hotelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setSocialButton(title: "HOTEL")
        button.addTarget(self, action: #selector(handleHotelButton), for: .touchUpInside)
        return button
    }()
    
    lazy var creteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setSocialButton(title: "CRETE".localized())
        button.addTarget(self, action: #selector(handleCreteButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        if !isLoggedIn() {
            perform(#selector(showLoginController), with: nil, afterDelay: 0)
            
            return
        }
        
        setupHotelData()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setupHotelData), name: .resetHomeView, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .resetHomeView, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func setupHotelData() {
        if let hotelInfo = appDelegate.hotelInfo {
            self.hotelInfo = hotelInfo
            setHotleName()
        }
        
        if let imageUrl = appDelegate.homeBackgroundImageUrl {
            self.setBackgroundImage(with: imageUrl)
        }
        
        if let _ = hotelInfo { return }
        handleGetHotelInfo()
        
    }
}

extension HomeController {
    
    @objc fileprivate func handleGetHotelInfo() {
        
        guard ReachabilityManager.shared.internetIsUp else {
            self.showPMAlertOkay(title: "Internet Error", message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        
        let hotelCode = UserDefaults.standard.getHotelCode()
        
        let request = Hotel.HotelInfoRequest(code: hotelCode)
        
        APIService.sharedInstance.handleGetHotelInfo(request) { (result: Hotel.ResultHotelInfo) in
            switch result {
            case .failure(let error):
                print(error)
                self.setDefaultBackgroundImage()
            case .success(let response):
                
                if let hotelInfo = response.result?.AddHotel {
                    self.hotelInfo = hotelInfo
                    
                    appDelegate.hotelInfo = hotelInfo
                    self.fetchHotelBackground()
                    if let hotelIdString = hotelInfo.id, let hotelId = Int(hotelIdString), let hotelName = hotelInfo.hotelname {
                        let userDefaults = UserDefaults.standard
                        userDefaults.setHotelId(hotelId)
                        userDefaults.setHotelName(hotelName)
                    }
                    
                } else {
                    self.setDefaultBackgroundImage()
                }
            }
        }
    }
}


extension HomeController {
    
    func setHotleName() {
        
        guard let hotelInfo = self.hotelInfo else { return }
        
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
        hotelButton.setTitle(hotelName, for: .normal)
        creteButton.setTitle("CRETE".localized(), for: .normal)
    }
    
    func fetchHotelBackground() {
        
        guard let hotelIdString = self.hotelInfo?.id, let hotelId = Int(hotelIdString) else { return }
        
        setHotleName()
        
        let request = GeneralRequest(id: hotelId)
        
        APIService.sharedInstance.handleGetHotelBackground(request) { (result: Hotel.ResultHotelBackground) in
            
            switch result {
            case .failure(let error):
                print(error)
                self.setDefaultBackgroundImage()
            case .success(let response):
                let imageUrl = response.result.Background?.image
                appDelegate.homeBackgroundImageUrl = imageUrl
                self.setBackgroundImage(with: imageUrl)
            }
        }
        
    }
    
    func setBackgroundImage(with imageUrl: String?) {
        if let imageUrl = imageUrl {
            self.backgroundImageView.loadSDWebImageWithUrlString(imageUrl)
        } else {
            self.setDefaultBackgroundImage()
        }
    }
    
    func setDefaultBackgroundImage() {
        let image = UIImage(named: "homeBackground.jpg")
        DispatchQueue.main.async {
            self.backgroundImageView.image = image
        }
        
    }
}

extension HomeController {
    
    @objc fileprivate func handleCreteButton() {
        let creteMenuController = CreteMenuController(collectionViewLayout: UICollectionViewFlowLayout())
        creteMenuController.navigationItem.title = "CRETE".localized()
        navigationController?.pushViewController(creteMenuController, animated: true)
    }
    
    @objc fileprivate func handleHotelButton() {
        
        let hotelMenuController = HotelMenuController(collectionViewLayout: UICollectionViewFlowLayout())
        hotelMenuController.hotelInfo = self.hotelInfo
        navigationController?.pushViewController(hotelMenuController, animated: true)
    }
}

extension HomeController {
    
    @objc fileprivate func showLoginController() {
        let loginController = LoginController()
        let navController = UINavigationController(rootViewController: loginController)
        present(navController, animated: true, completion: nil)
    }
    
    fileprivate func isLoggedIn() -> Bool {
        
        return UserDefaults.standard.isLoggedIn()
    }
}

extension HomeController {
    
    fileprivate func setupViews() {
        
        setupBackground()
        setupButtons()
    }
    
    private func setupButtons() {
        
        view.addSubview(creteButton)
        creteButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 80, paddingRight: 30, width: 0, height: 40)
        
        view.addSubview(hotelButton)
        hotelButton.anchor(top: nil, left: creteButton.leftAnchor, bottom: creteButton.topAnchor, right: creteButton.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 40)
    }
    
    private func setupBackground() {
        view.backgroundColor = .white
        
        view.addSubview(backgroundImageView)
        backgroundImageView.anchorToTop(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
    }
}
