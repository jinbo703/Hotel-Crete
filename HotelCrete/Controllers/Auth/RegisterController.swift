//
//  RegisterController.swift
//  HotelCrete
//
//  Created by John Nik on 17/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import SideMenuController
import SVProgressHUD
import OneSignal
import Localize_Swift

class RegisterController: UIViewController {
    
    let SUGGEST_TEXT = "It is suggested that at least one guest from each room should register in order to receive messages from the hotel and to be able to fill in the hotel questionnaire"
    
    var logoImageView = UIImageView()
    
    var lineView = UIView()
    
    lazy var suggestTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = StyleGuideManager.mainLightBlueBackgroundColor
        textView.text = SUGGEST_TEXT.localized()
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.delegate = self
        return textView
    }()
    
    lazy var surnameTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        textField.placeholder = "Surname".localized()
        textField.text = ""
        textField.topplessBorderColor = StyleGuideManager.mainLightBlueBackgroundColor
        textField.textColor = StyleGuideManager.mainLightBlueBackgroundColor
        return textField
    }()
    
    lazy var lastnameTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        textField.placeholder = "Name".localized()
        textField.text = ""
        textField.topplessBorderColor = StyleGuideManager.mainLightBlueBackgroundColor
        textField.textColor = StyleGuideManager.mainLightBlueBackgroundColor
        return textField
    }()
    
    lazy var emailTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        textField.placeholder = "Email (Optional)".localized()
        textField.text = ""
        textField.topplessBorderColor = StyleGuideManager.mainLightBlueBackgroundColor
        textField.textColor = StyleGuideManager.mainLightBlueBackgroundColor
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let latinLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Please use Latin characters".localized()
        label.textColor = StyleGuideManager.mainLightBlueBackgroundColor
        label.textAlignment = .center
        return label
    }()
    
    
    lazy var checkinDateView: CheckDateView = {
        
        let view = CheckDateView()
        view.dateLabelTitle = "Check-in date".localized()
        view.registerControler = self
        view.delegate = self
        return view
    }()
    
    lazy var checkoutDateView: CheckDateView = {
        
        let view = CheckDateView()
        view.dateLabelTitle = "Check-out date".localized()
        view.registerControler = self
        view.delegate = self
        return view
    }()
    
    lazy var dateStackView: UIStackView = {
        
        let stackView = UIStackView(arrangedSubviews: [checkinDateView, checkoutDateView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register".localized(), for: .normal)
        button.setTitleColor(StyleGuideManager.mainLightBlueBackgroundColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.layer.borderColor = StyleGuideManager.mainLightBlueBackgroundColor.cgColor
        button.layer.borderWidth = 2
        button.layer.masksToBounds = true
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    lazy var skipButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Skip".localized(), for: .normal)
        button.setTitleColor(StyleGuideManager.mainLightBlueBackgroundColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleGetHotelInfo), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    @objc func handleRegister() {
        
        guard ReachabilityManager.shared.internetIsUp else {
            self.showPMAlertOkay(title: "Internet Error".localized(), message: AlertMessages.failedInternetTitle.rawValue.localized())
            return
        }
        
        if !checkInvalid() {
            return
        }
        
        guard let surname = surnameTextField.text,
            let name = lastnameTextField.text else { return }
        let checkIn = checkinDateView.dateLabel.text
        let checkOut = checkoutDateView.dateLabel.text
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
                self.showErrorMessage(title: "Fail".localized(), message: AlertMessages.somethingWentWrong.rawValue.localized())
            case .success(let response):
                
                if let id = response.id {
                    UserDefaults.standard.setUserId(id)
                    self.handleGetHotelInfo()
                } else {
                    self.showErrorMessage(title: "Register Fail".localized(), message: AlertMessages.invalidRegisterUser.rawValue.localized())
                }
            }
        }
    }
}

extension RegisterController {
    
    func handleSkip(hotelInfo: Hotel.HotelInfo) {
        guard let mainController = UIApplication.shared.keyWindow?.rootViewController as? SideMenuController else { return }
        let homeController = mainController.centerViewController.childViewControllers.first as! HomeController
        homeController.hotelInfo = hotelInfo
        homeController.fetchHotelBackground()
        let userDefaults = UserDefaults.standard
        userDefaults.setIsLoggedIn(value: true)
        self.dismiss(animated: true, completion: nil)
        
    }
}

extension RegisterController {
    
    func checkInvalid() -> Bool {
        
        if (surnameTextField.text?.isEmptyStr)! || !isValidSurname(surnameTextField.text!) {
            self.showErrorAlertWith("Invalid Surname".localized(), message: "Please enter a valid Surname".localized())
            return false
        }
        
        if (lastnameTextField.text?.isEmptyStr)! || !isValidLastname(lastnameTextField.text!) {
            self.showErrorAlertWith("Invalid name".localized(), message: "Please enter a valid name".localized())
            return false
        }
        
        // data optional
        /*
        if (checkinDateView.dateLabel.text?.isEmptyStr)! || !isValidCheckinDate(checkinDateView.dateLabel.text!) {
            self.showErrorAlertWith("Invalid Checkin Date".localized(), message: "Please choose a Checkin Date".localized())
            return false
        }
        
        if (checkoutDateView.dateLabel.text?.isEmptyStr)! || !isValidCheckoutDate(checkoutDateView.dateLabel.text!) {
            self.showErrorAlertWith("Invalid Checkout Date".localized(), message: "Please choose a Checkout Date".localized())
            return false
        }
         */
        
        return true
    }
    
    fileprivate func isValidSurname(_ suername: String) -> Bool {
        if suername.count >= 1 {
            return true
        } else {
            return false
        }
    }
    
    fileprivate func isValidLastname(_ lastname: String) -> Bool {
        if lastname.count >= 1 {
            return true
        } else {
            return false
        }
    }
    
    fileprivate func isValidCheckinDate(_ date: String) -> Bool {
        if date.count >= 1 {
            return true
        } else {
            return false
        }
    }
    
    fileprivate func isValidCheckoutDate(_ date: String) -> Bool {
        if date.count >= 1 {
            return true
        } else {
            return false
        }
    }
    
}

extension RegisterController {
    
    func showErrorMessage(title: String, message: String) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.showPMAlertOkay(title: title, message: message)
        }
    }
}

extension RegisterController {
    
    @objc fileprivate func handleGetHotelInfo() {
        
        guard ReachabilityManager.shared.internetIsUp else {
            self.showPMAlertOkay(title: "Internet Error", message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        
        let hotelCode = UserDefaults.standard.getHotelCode()
        
        let request = Hotel.HotelInfoRequest(code: hotelCode)
        
        APIService.sharedInstance.handleGetHotelInfo(request) { (result: Hotel.ResultHotelInfo) in
            switch result {
            case .failure( _):
                self.showErrorMessage(title: "Fail", message: AlertMessages.somethingWentWrong.rawValue)
            case .success(let response):
                
                if let hotelInfo = response.result?.AddHotel {
                    appDelegate.hotelInfo = hotelInfo
                    self.handleSkip(hotelInfo: hotelInfo)
                    if let hotelIdString = hotelInfo.id, let hotelId = Int(hotelIdString) {
                        UserDefaults.standard.setHotelId(hotelId)
                    }
                } else {
                    self.showErrorMessage(title: "Register Fail", message: AlertMessages.invalidRegisterUser.rawValue)
                }
            }
        }
    }
}

extension RegisterController: CheckDateViewDelegate {
    
    func handleDate(_ date: String, sender: CheckDateView) {
        
    }
}

extension RegisterController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: 350.0, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}

extension RegisterController {
    
    fileprivate func setupViews() {
        
        setupBackground()
        setupNavBar()
        setupTextStuff()
        setupTextFields()
        setupDateView()
        setupEmail()
        setupRegisterButton()
        setupSkipButton()
    }
    
    private func setupSkipButton() {
        
        view.addSubview(skipButton)
        skipButton.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 130, height: 40)
        skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        lineView.backgroundColor = StyleGuideManager.mainLightBlueBackgroundColor
        
        view.addSubview(lineView)
        lineView.anchor(top: nil, left: skipButton.leftAnchor, bottom: skipButton.bottomAnchor, right: skipButton.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
        
    }
    
    private func setupRegisterButton() {
        
        view.addSubview(registerButton)
        registerButton.anchor(top: emailTextField.bottomAnchor, left: emailTextField.leftAnchor, bottom: nil, right: emailTextField.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
    }
    
    private func setupEmail() {
        
        view.addSubview(emailTextField)
        emailTextField.anchor(top: dateStackView.bottomAnchor, left: surnameTextField.leftAnchor, bottom: nil, right: surnameTextField.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
    }
    
    fileprivate func setupDateView() {
        
        view.addSubview(dateStackView)
        dateStackView.anchor(top: lastnameTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: FLAG_BUTTON_PADDING, paddingBottom: 0, paddingRight: FLAG_BUTTON_PADDING * 2, width: 0, height: 40)
    }
    
    fileprivate func setupTextFields() {
        
        view.addSubview(surnameTextField)
        surnameTextField.anchor(top: latinLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 300, height: 40)
        surnameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(lastnameTextField)
        lastnameTextField.anchor(top: surnameTextField.bottomAnchor, left: surnameTextField.leftAnchor, bottom: nil, right: surnameTextField.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        lastnameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func setupTextStuff() {
        
        view.addSubview(suggestTextView)
        suggestTextView.anchor(top: logoImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 350, height: 50)
        suggestTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        textViewDidChange(suggestTextView)
        
        view.addSubview(latinLabel)
        latinLabel.anchor(top: suggestTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        
    }
    
    private func setupNavBar() {
        
        navigationController?.isNavigationBarHidden = true
        
    }
    
    private func setupBackground() {
        view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let logoImage = UIImage(named: AssetName.logo.rawValue)
        logoImageView.image = logoImage
        
        guard let imageWidth = logoImage?.size.width,
            let imageHeight = logoImage?.size.height else { return }
        
        view.addSubview(logoImageView)
        logoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 200 * imageHeight / imageWidth)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
