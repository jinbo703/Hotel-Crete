//
//  GuideCreteDataController.swift
//  HotelCrete
//
//  Created by John Nik on 25/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class GuideCreteDataController: UIViewController {
    
    let cellId = "cellId"
    let tableViewCellHeight: CGFloat = 60
    
    var tableViewHeightConstraint: NSLayoutConstraint?
    var guideCreteInfo: Crete.GuideCreteInfo?
    var guideCreteDatas: [Crete.GuideData] = []
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    let backgroundImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        fetchData()
    }
    
    func fetchData() {
        
        guard let guideCreteInfo = guideCreteInfo else { return }
        
        if let imageUrl = guideCreteInfo.GuideCrete?.image {
            backgroundImageView.loadSDWebImageWithUrlString(imageUrl)
        }
        
        if let guideCreteDatas = guideCreteInfo.GuideData {
            
            self.guideCreteDatas = guideCreteDatas
            self.tableViewHeightConstraint?.constant = CGFloat(guideCreteDatas.count) * tableViewCellHeight
            self.tableView.reloadData()
        }
    }
    
}

extension GuideCreteDataController {
    func getLocalizedString(from detail: Crete.GuideData) -> String? {
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

extension GuideCreteDataController {
    
    func didSelectGuideCreteData(_ guideCreteData: Crete.GuideData) {
        
        guard let details = guideCreteData.GuideBeache else { return }
        
        if guideCreteData.title == "By Area" {
            
            let areaController = GuideCreteDataAreaController(collectionViewLayout: UICollectionViewFlowLayout())
            areaController.navigationItem.title = getLocalizedString(from: guideCreteData)
            areaController.guideDataDetails = details
            self.navigationController?.pushViewController(areaController, animated: true)
        } else {
            
            let dataTopController = GuideCreteDataTopController(collectionViewLayout: UICollectionViewFlowLayout())
            dataTopController.navigationItem.title = getLocalizedString(from: guideCreteData)
            dataTopController.guideDataDetails = details
            
            self.navigationController?.pushViewController(dataTopController, animated: true)
        }
        
    }
}

extension GuideCreteDataController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guideCreteDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! GuideCreteDataCell
        cell.guideCreteDataController = self
        cell.guideCreteData = guideCreteDatas[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
}

extension GuideCreteDataController {
    
    @objc fileprivate func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
}

extension GuideCreteDataController {
    
    fileprivate func setupViews() {
        
        setupBackground()
        setupNavBar()
        setupTableView()
    }
    
    private func setupTableView() {
        
        tableView.register(GuideCreteDataCell.self, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        tableView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40).isActive = true
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint?.isActive = true
    }
    
    private func setupNavBar() {
        
        let image = UIImage(named: AssetName.back.rawValue)
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleDismiss))
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupBackground() {
        view.backgroundColor = .white
        
        view.addSubview(backgroundImageView)
        backgroundImageView.anchorToTop(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
    }
}
