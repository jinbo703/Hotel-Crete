//
//  SideController.swift
//  InstaChain
//
//  Created by John Nik on 2/4/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit
import SideMenuController
import SVProgressHUD
import PMAlertController
import Localize_Swift

class SideController: UIViewController {
    
    let cellId = "cellId"
    
    let availableLanguages = Localize.availableLanguages()
    
    var titles: [[String]] = []
    
    let backgroundImageView: UIImageView = {
        let backgroundImage = UIImage(named: "background")?.withRenderingMode(.alwaysOriginal)
        let backgooundImageView = UIImageView(image: backgroundImage)
        backgooundImageView.contentMode = .scaleAspectFill
        return backgooundImageView
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .white
        table.separatorStyle = .singleLine
        table.isScrollEnabled = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        resetLanguage()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetLanguage), name: NSNotification.Name( LCLLanguageChangeNotification), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func reloadTableView() {
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // Remove the LCLLanguageChangeNotification on viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
}

extension SideController {
    
    @objc func resetLanguage() {
        
        NotificationCenter.default.post(name: .resetHomeView, object: nil)
        
        titles = [[AssetName.home.rawValue, "Home Page".localized()],
                  [AssetName.message.rawValue, "Message".localized()],
                  [AssetName.map.rawValue, "Map".localized()],
                  [AssetName.weather.rawValue, "Weather".localized()],
                  [AssetName.books.rawValue, "Greek Words".localized()],
                  [AssetName.information.rawValue, "General Info".localized()],
                  [AssetName.telephone.rawValue, "Useful tel. numbers".localized()],
                  [AssetName.language.rawValue, "Change Language".localized()],
                  [AssetName.logout.rawValue, "Change Hotel Code".localized()]]
        
        self.tableView.reloadData()
    }
}

extension SideController {
}

extension SideController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        
        let title = titles[indexPath.row][1]
        cell.imageView?.image = UIImage(named: titles[indexPath.row][0])?.withRenderingMode(.alwaysTemplate)
        cell.imageView?.tintColor = .darkGray
        cell.textLabel?.text = title
        cell.textLabel?.textColor = .darkGray
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var navController: UINavigationController?
        
        if indexPath.row == 0 {
            
            let homeController = HomeController()
            navController = NavigationController(rootViewController: homeController)
            
        } else if indexPath.row == 1 {
            
            if let _ = UserDefaults.standard.getUserId() {
                let messageController = MessagesController(collectionViewLayout: UICollectionViewFlowLayout())
                navController = UINavigationController(rootViewController: messageController)
            } else {
                
                self.showPMAlertDefault("Sorry, you should register to get messages from your hotel", message: "Do you want to register now?", action: {
                    
                    let generalRegisterController = GeneralRegisterController()
                    let navController = UINavigationController(rootViewController: generalRegisterController)
                    
                    self.present(navController, animated: true, completion: nil)
                })
            }
            
        } else if indexPath.row == 2 {
            let hotelMapController = HotelMapController()
            navController = UINavigationController(rootViewController: hotelMapController)
        } else if indexPath.row == 3 {
            
            let weatherController = WeatherController()
            navController = UINavigationController(rootViewController: weatherController)
            
        } else if indexPath.row == 4 {
            let greekWordController = GreekWordsController()
            navController = UINavigationController(rootViewController: greekWordController)
        } else if indexPath.row == 5 {
            let infoController = GeneralInfoController()
            navController = UINavigationController(rootViewController: infoController)
        } else if indexPath.row == 6 {
            
            let numbersController = UsefulNumbersController()
            navController = UINavigationController(rootViewController: numbersController)
        } else if indexPath.row == 7 {
            let actionSheet = UIAlertController(title: nil, message: "Change Language".localized(), preferredStyle: UIAlertControllerStyle.actionSheet)
            
            
            for i in 0..<availableLanguages.count {
                
                let language = availableLanguages[i]
                var displayName = ""
                if i == 0 {
                    displayName = "German".localized(using: "ButtonTitles")
                } else if i == 1 {
                    displayName = "English".localized(using: "ButtonTitles")
                } else if i == 2 {
                    displayName = "French".localized(using: "ButtonTitles")
                } else if i == 3 {
                    displayName = "Italian".localized(using: "ButtonTitles")
                } else {
                    displayName = "Russian".localized(using: "ButtonTitles")
                }
                
                let languageAction = UIAlertAction(title: displayName, style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    Localize.setCurrentLanguage(language)
                })
                actionSheet.addAction(languageAction)
            }
            
            //it's simple code for showing languages
            /*
            for language in availableLanguages {
                let displayName = Localize.displayNameForLanguage(language)
                let languageAction = UIAlertAction(title: displayName, style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    Localize.setCurrentLanguage(language)
                })
                actionSheet.addAction(languageAction)
            }
            */
            
            let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertActionStyle.cancel, handler: {
                (alert: UIAlertAction) -> Void in
            })
            actionSheet.addAction(cancelAction)
            self.present(actionSheet, animated: true, completion: nil)
        } else if indexPath.row == 8 {
            
            self.handleLogOff()
            return
        } else {
            
            let randomController = UIViewController()
            randomController.view.backgroundColor = .white
            randomController.navigationItem.title = titles[indexPath.row][1]
            navController = UINavigationController(rootViewController: randomController)
        }
        
        guard let embedController = navController else { return }
        
        sideMenuController?.embed(centerViewController: embedController)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: SIDE_MENU_WIDTH, height: 170))
        containerView.backgroundColor = StyleGuideManager.mainLightBlueBackgroundColor
        
        let usernamelabel = UILabel(frame: CGRect(x: 10, y: 60, width: 150, height: 20))
        usernamelabel.font = UIFont.systemFont(ofSize: 20)
        usernamelabel.textColor = .white
        usernamelabel.textAlignment = .center
        usernamelabel.text = "Menu".localized()
        containerView.addSubview(usernamelabel)
        
        return containerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
}


extension SideController {
    
}

//MARK: fetch user profile

//MARK: handle logout
extension SideController {
    @objc fileprivate func handleLogOff() {
        
        
        self.showPMAlertDefault("Hotel & Crete", message: "Are you sure you want to change your hotel code?", firstTitle: "Yes", secondeTitle: "No") {
            
            let userDefaults = UserDefaults.standard
            userDefaults.setIsLoggedIn(value: false)
            userDefaults.setUserId(nil)
            
            let homeController = HomeController()
            let navController = UINavigationController(rootViewController: homeController)
            self.sideMenuController?.embed(centerViewController: navController)
        }
    }
}

//MARK: setup Views
extension SideController {
    
    fileprivate func setupViews() {
        setupBackground()
        setupTableView()
    }
    
    private func setupBackground() {
        
        view.backgroundColor = StyleGuideManager.mainLightBlueBackgroundColor
        
//        view.addSubview(backgroundImageView)
//        backgroundImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    
    
    private func setupTableView() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
}
