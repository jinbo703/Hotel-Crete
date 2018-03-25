//
//  GeneralInfoController.swift
//  HotelCrete
//
//  Created by John Nik on 28/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import SVProgressHUD

class GeneralInfoController: UIViewController {
    
    let cellId = "cellId"
    
    var services = [Service]()
    
    var expandedUsefulInfos: [UsefulInfo.ExpandedUsefulInfo] = []
    
    let backgroundImageView: UIImageView = {
        let image = UIImage(named: "generalInfo")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchUsefulInfos()
    }
    
    
}

extension GeneralInfoController {
    
    func showErrorMessage(title: String, message: String) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.showPMAlertOkay(title: title, message: message)
        }
    }
}

extension GeneralInfoController {
    
    func fetchUsefulInfos() {
        
        guard ReachabilityManager.shared.internetIsUp else {
            
            self.showPMAlertOkay(title: "Internet Error", message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        
        APIService.sharedInstance.handleGetUsefulInfo { (result: UsefulInfo.ResultUsefulInfo) in
            switch result {
            case .failure(_):
                self.showErrorMessage(title: "Server Error", message: AlertMessages.somethingWentWrong.rawValue)
            case .success(let response):
                if let usefulInfos = response.result {
                    
                    self.setupExpandedUsefulInfos(usefulInfos)
                }
            }
        }
        
    }
    
    func setupExpandedUsefulInfos(_ usefulInfos: [UsefulInfo.GroupedUsefulInfo]) {
        
        for usefulInfo in usefulInfos {
            
            var title: String?
            var detail: String?
            
            let info = usefulInfo.UsefulInfo
            if currentLanguage() == DisplayName.england.rawValue {
                title = info.title
                detail = info.description
            } else if currentLanguage() == DisplayName.france.rawValue {
                title = info.title_french
                detail = info.description_french
            } else if currentLanguage() == DisplayName.germany.rawValue {
                title = info.title_german
                detail = info.description_german
            } else if currentLanguage() == DisplayName.italy.rawValue {
                title = info.title_italian
                detail = info.description_italian
            } else {
                title = info.title_russian
                detail = info.description_russian
            }
            
            let expandedUsefulInfo = UsefulInfo.ExpandedUsefulInfo(isExpanded: true, title: title, description: [detail])
            self.expandedUsefulInfos.append(expandedUsefulInfo)
            
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
}

extension GeneralInfoController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return expandedUsefulInfos.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let description = expandedUsefulInfos[section].description {
            if expandedUsefulInfos[section].isExpanded {
                return 0
            }
            
            return description.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! GeneralInfoCell
        
        if let detail = expandedUsefulInfos[indexPath.section].description {
            cell.detail = detail[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let detail = expandedUsefulInfos[indexPath.section].description![indexPath.row] else { return 0 }
        
        let estimatedHeight = GlobalFunction.estimateFrameForText(text: detail.htmlToString, width: view.frame.width - 40, font: 17.0).height
        
        return estimatedHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let button = UIButton(type: .system)
        
        var plusTitle = "+"
        var minusTitle = "-"
        if let serviceName = expandedUsefulInfos[section].title {
            plusTitle += " " + serviceName
            minusTitle += " " + serviceName
        }
        
        button.setTitle(expandedUsefulInfos[section].isExpanded ? plusTitle : minusTitle, for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        
        button.tag = section
        
        return button
    }
    
}
extension GeneralInfoController {
    @objc private func handleExpandClose(button: UIButton) {
        
        let section = button.tag
        
        var indexPaths = [IndexPath]()
        
        guard let serviceDetail = expandedUsefulInfos[section].description else { return }
        for row in serviceDetail.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = expandedUsefulInfos[section].isExpanded
        expandedUsefulInfos[section].isExpanded = !isExpanded
        
        var plusTitle = "+"
        var minusTitle = "-"
        if let serviceName = expandedUsefulInfos[section].title {
            plusTitle += " " + serviceName
            minusTitle += " " + serviceName
        }
        
        button.setTitle(isExpanded ? minusTitle : plusTitle, for: .normal)
        
        if isExpanded {
            tableView.insertRows(at: indexPaths, with: .fade)
            
        } else {
            tableView.deleteRows(at: indexPaths, with: .fade)
        }
        
    }
}

extension GeneralInfoController {
    
    fileprivate func setupViews() {
        
        setupBackground()
        setupTableView()
    }
    
    private func setupBackground() {
        view.backgroundColor = .white
        
        navigationItem.title = "General Info".localized()
        
        view.addSubview(backgroundImageView)
        backgroundImageView.anchorToTop(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
    }
    
    private func setupTableView() {
        
        tableView.register(GeneralInfoCell.self, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        tableView.anchorToTop(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
    }
}
