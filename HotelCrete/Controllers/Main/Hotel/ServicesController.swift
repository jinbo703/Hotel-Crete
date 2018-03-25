//
//  ServicesController.swift
//  HotelCrete
//
//  Created by John Nik on 18/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class ServicesController: UIViewController {
    
    let cellId = "cellId"
    
    var services = [Service]()
    
    let backgroundImageView: UIImageView = {
        let image = UIImage(named: "services2")
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
        fetchServicesFromServer()
    }
    
    func fetchServicesFromServer() {
        
        guard ReachabilityManager.shared.internetIsUp else {
            self.fetchServices()
            return
        }
        
        let hotelId = UserDefaults.standard.getHotelId()
        
        let id = Hotel.HotelId(id: hotelId)
        let service = Hotel.ServiceRequest(Service: id)
        
        APIService.sharedInstance.handleGetHotelService(service) { (result: Hotel.ResultHotelService) in
            
            switch result {
            case .failure(_):
                self.fetchServices()
            case .success(let response):
                if let hotelServices = response.result {
                    self.setHotelServices(hotelServices)
                }
            }
            
        }
    }
    
    
    
    func fetchServices() {
        
        let service1 = Service(isExpanded: true, serviceName: "Reception", serviceDetail: ["The hotel reception desk is open 24 hours with mutlingual staff ready to provide every information and service available for all our guests.\nYou may also call the reception desk from your room by dialing 0"])
        let service2 = Service(isExpanded: true, serviceName: "Check-In", serviceDetail: ["The hotel reception desk is open 24 hours with mutlingual staff ready to provide every information and service available for all our guests.\nYou may also call the reception desk from your room by dialing 0"])
        let service3 = Service(isExpanded: true, serviceName: "Check-Out", serviceDetail: ["The hotel reception desk is open 24 hours with mutlingual staff ready to provide every information and service available for all our guests.\nYou may also call the reception desk from your room by dialing 0"])
        let service4 = Service(isExpanded: true, serviceName: "Late Check-Out / Day Use", serviceDetail: ["The hotel reception desk is open 24 hours with mutlingual staff ready to provide every information and service available for all our guests.\nYou may also call the reception desk from your room by dialing 0"])
        let service5 = Service(isExpanded: true, serviceName: "Safety Box", serviceDetail: ["The hotel reception desk is open 24 hours with mutlingual staff ready to provide every information and service available for all our guests.\nYou may also call the reception desk from your room by dialing 0"])
        
        services.append(service1)
        services.append(service2)
        services.append(service3)
        services.append(service4)
        services.append(service5)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
}

extension ServicesController {
    
    fileprivate func setHotelServices(_ hotelServices: [Hotel.Service]) {
        
        for hotelService in hotelServices {
            
            var title: String?
            var detail: String?
            
            let service = hotelService.Service
            if currentLanguage() == DisplayName.england.rawValue {
                title = service?.title
                detail = service?.description
            } else if currentLanguage() == DisplayName.france.rawValue {
                title = service?.title_french
                detail = service?.description_french
            } else if currentLanguage() == DisplayName.germany.rawValue {
                title = service?.title_german
                detail = service?.description_german
            } else if currentLanguage() == DisplayName.italy.rawValue {
                title = service?.title_italian
                detail = service?.description_italian
            } else {
                title = service?.title_russian
                detail = service?.description_russian
            }
            
            let tempService = Service(isExpanded: true, serviceName: title, serviceDetail: [detail])
            self.services.append(tempService)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
}

extension ServicesController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let detail = services[section].serviceDetail {
            if services[section].isExpanded {
                return 0
            }
            return detail.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ServiceCell
        
        if let detail = services[indexPath.section].serviceDetail {
            cell.detail = detail[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let detail = services[indexPath.section].serviceDetail![indexPath.row] else { return 0 }
        
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
        if let serviceName = services[section].serviceName {
            plusTitle += " " + serviceName
            minusTitle += " " + serviceName
        }
        
        button.setTitle(services[section].isExpanded ? plusTitle : minusTitle, for: .normal)
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
extension ServicesController {
    @objc private func handleExpandClose(button: UIButton) {
        
        let section = button.tag
        
        var indexPaths = [IndexPath]()
        
        guard let serviceDetail = services[section].serviceDetail else { return }
        
        if serviceDetail[0]?.count == 0 { return }
        
        for row in serviceDetail.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = services[section].isExpanded
        services[section].isExpanded = !isExpanded
        
        var plusTitle = "+"
        var minusTitle = "-"
        if let serviceName = services[section].serviceName {
            plusTitle += " " + serviceName
            minusTitle += " " + serviceName
        }
        
        button.setTitle(isExpanded ? minusTitle : plusTitle, for: .normal)
        
        if isExpanded {
            tableView.insertRows(at: indexPaths, with: .none)
            
        } else {
            tableView.deleteRows(at: indexPaths, with: .none)
        }
        
    }
}

extension ServicesController {
    
    @objc fileprivate func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
}

extension ServicesController {
    
    fileprivate func setupViews() {
        
        setupBackground()
        setupTableView()
        setupNavBar()
    }
    
    private func setupBackground() {
        view.backgroundColor = .white
        
        view.addSubview(backgroundImageView)
        backgroundImageView.anchorToTop(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
    }
    
    private func setupNavBar() {
        
        let image = UIImage(named: AssetName.back.rawValue)
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleDismiss))
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupTableView() {
        
        tableView.register(ServiceCell.self, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        tableView.anchorToTop(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
    }
}
