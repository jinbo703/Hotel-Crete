//
//  LoginController.swift
//  HotelCrete
//
//  Created by John Nik on 14/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import SVProgressHUD
import Localize_Swift

class LoginController: UIViewController {
    
    let availableLanguages = Localize.availableLanguages()
    
    let latinLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Please use Latin characters".localized()
        label.textColor = StyleGuideManager.mainLightBlueBackgroundColor
        label.textAlignment = .center
        return label
    }()
    
    lazy var codeTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        textField.placeholder = "Enter a code".localized()
        textField.text = ""
        textField.topplessBorderColor = StyleGuideManager.mainLightBlueBackgroundColor
        textField.textColor = StyleGuideManager.mainLightBlueBackgroundColor
        textField.keyboardType = .numberPad
        return textField
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next".localized(using: "ButtonTitles"), for: .normal)
        button.setTitleColor(StyleGuideManager.mainLightBlueBackgroundColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.layer.borderColor = StyleGuideManager.mainLightBlueBackgroundColor.cgColor
        button.layer.borderWidth = 2
        button.layer.masksToBounds = true
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    lazy var flagsStackView: UIStackView = {
        
        let stackView = UIStackView(arrangedSubviews: [englandButtonView, germanyButtonView, russiaButtonView, franceButtonView, italyButtonView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var englandButtonView: FlagButtonView = {
        let view = FlagButtonView()
        view.flag = .england
        view.displayName = .england

        view.delegate = self
        return view
    }()
    
    lazy var italyButtonView: FlagButtonView = {
        let view = FlagButtonView()
        view.flag = .italy
        view.displayName = .italy
        view.delegate = self
        return view
    }()
    
    lazy var russiaButtonView: FlagButtonView = {
        let view = FlagButtonView()
        view.flag = .russia
        view.displayName = .russia
        view.delegate = self
        return view
    }()
    
    lazy var franceButtonView: FlagButtonView = {
        let view = FlagButtonView()
        view.flag = .france
        view.displayName = .france
        view.delegate = self
        return view
    }()
    
    lazy var germanyButtonView: FlagButtonView = {
        let view = FlagButtonView()
        view.flag = .germany
        view.displayName = .germany
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        checkCurrentLanguage()
    }
    
    
    
    // Add an observer for LCLLanguageChangeNotification on viewWillAppear. This is posted whenever a language changes and allows the viewcontroller to make the necessary UI updated. Very useful for places in your app when a language change might happen.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(resetLanguage), name: NSNotification.Name( LCLLanguageChangeNotification), object: nil)
    }
    
    // Remove the LCLLanguageChangeNotification on viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

extension LoginController {
    
    func checkCurrentLanguage() {
        
        let currentLanguage = Localize.currentLanguage()
        
        let buttonViews = [self.englandButtonView, self.germanyButtonView, self.russiaButtonView, self.franceButtonView, self.italyButtonView]
        
        for buttonView in buttonViews {
            
            if let displayName = buttonView.displayName, currentLanguage == displayName.rawValue {
                buttonView.flagButton.setSelected(true, withAnimation: true)
                buttonView.flagLabel.font = UIFont.boldSystemFont(ofSize: 15)
            }
        }
    }
    
    @objc func resetLanguage() {
        
        latinLabel.text = "Please use Latin characters".localized()
        codeTextField.placeholder = "Enter a code".localized()
        nextButton.setTitle("Next".localized(using: "ButtonTitles"), for: .normal)
        
        let buttonViews = [self.englandButtonView, self.germanyButtonView, self.russiaButtonView, self.franceButtonView, self.italyButtonView]
        
        for buttonView in buttonViews {
            
            if let flag = buttonView.flag {
                buttonView.flag = flag
            }
            
        }
    }
}

extension LoginController: FlagButtonViewDelegate {
    
    func handleFlagButtonView(sender: FlagButtonView, isButtonSelected: Bool) {
        
        if !isButtonSelected {
            
            let buttonViews = [self.englandButtonView, self.germanyButtonView, self.russiaButtonView, self.franceButtonView, self.italyButtonView]
            
            for buttonView in buttonViews {
                if sender != buttonView {
                    
                    if buttonView.flagButton.isSelected {
                        buttonView.flagButton.isSelected = false
                        buttonView.flagButton.setSelected(false, withAnimation: true)
                        buttonView.flagLabel.font = UIFont.systemFont(ofSize: 15)
                    }
                    
                }
            }
            
            for language in availableLanguages {
                
                let displayName = Localize.displayNameForLanguage(language)
                if let buttonDisplayName = sender.displayName?.rawValue {
                    
                    if Localize.displayNameForLanguage(buttonDisplayName) == displayName {
                        Localize.setCurrentLanguage(language)
                    }
                }
            }
        }
        
    }
}

extension LoginController {
    
    func showErrorMessage(title: String, message: String) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.showPMAlertOkay(title: title, message: message)
        }
    }
}

extension LoginController {
    @objc fileprivate func handleNext() {
        
        guard ReachabilityManager.shared.internetIsUp else {
            self.showPMAlertOkay(title: "Internet Error", message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        
        if !checkInvalid() {
            return
        }
        
        guard let code = codeTextField.text, let number = Int(code) else { return }
        
        let hotelNumber = Hotel.HotelNumber(hotelNumber: number)
        
        APIService.sharedInstance.checkHotelCode(hotelNumber) { (result: Hotel.CheckHotelNumber) in
            switch result {
            case .failure( _):
                self.showErrorMessage(title: "Fail", message: AlertMessages.somethingWentWrong.rawValue)
            case .success(let response):
                if response.res == Status.success.rawValue {
                    
                    UserDefaults.standard.setHotelCode(number)
                    
                    let registerController = RegisterController()
                    self.navigationController?.pushViewController(registerController, animated: true)
                } else {
                    self.showErrorMessage(title: "Fail", message: AlertMessages.invalidHotelNumber.rawValue)
                }
            }
        }
    }
}

extension LoginController {
    
    fileprivate func checkInvalid() -> Bool {
        
        if (codeTextField.text?.isEmptyStr)! || !isValidCode(codeTextField.text!) {
            self.showErrorAlertWith("Invalid Code", message: "Please enter a valid code")
            return false
        }
        
        return true
    }
    
    fileprivate func isValidCode(_ code: String) -> Bool {
        if code.count >= 1 {
            return true
        } else {
            return false
        }
    }
    
}

extension LoginController {
    
    fileprivate func setupViews() {
        
        setupBackground()
        setupNavBar()
        setupButtons()
        setupLatinLabel()
        setupCodeTextField()
        setupNextButton()
    }
    
    private func setupNavBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupNextButton() {
        
        view.addSubview(nextButton)
        nextButton.anchor(top: nil, left: codeTextField.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: codeTextField.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 40, paddingRight: 0, width: 0, height: 40)
    }
    
    private func setupCodeTextField() {
        
        view.addSubview(codeTextField)
        codeTextField.anchor(top: latinLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 300, height: 40)
        codeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupLatinLabel() {
        
        view.addSubview(latinLabel)
        latinLabel.anchor(top: flagsStackView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
    }
    
    private func setupButtons() {
        
        //button size 256 * 168
        
        let flagImageWidth: CGFloat = 256
        let flagImageHeight: CGFloat = 168
        
        let frameWidth = DEVICE_WIDTH / 5 - FLAG_BUTTON_PADDING * 2
        let height = (frameWidth - FLAG_BUTTON_PADDING * 2) * flagImageHeight / flagImageWidth + 30
        
        
        
        
        view.addSubview(flagsStackView)
        flagsStackView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: FLAG_BUTTON_PADDING, paddingBottom: 0, paddingRight: FLAG_BUTTON_PADDING, width: 0, height: height)
        flagsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupBackground() {
        view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let logoImage = UIImage(named: AssetName.logo.rawValue)
        let logoImageView = UIImageView(image: logoImage)
        
        guard let imageWidth = logoImage?.size.width,
            let imageHeight = logoImage?.size.height else { return }
        
        view.addSubview(logoImageView)
        logoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 80, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 200 * imageHeight / imageWidth)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
