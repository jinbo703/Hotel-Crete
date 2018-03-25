//
//  SocialMediaController.swift
//  HotelCrete
//
//  Created by John Nik on 18/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit



class SocialMediaController: UIViewController {
    
    let cellId = "cellId"
    
    let tableViewCellHeight: CGFloat = 60
    
    var socialMedias: [SocialMedia] = []
    
    var tableViewHeightConstraint: NSLayoutConstraint?
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.isScrollEnabled = false
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
        
        let image = UIImage(named: "socialBackground.jpg")
        backgroundImageView.image = image
        
        guard ReachabilityManager.shared.internetIsUp else {
            fetchTempData()
            return
        }
        
        let hotelId = UserDefaults.standard.getHotelId()
        let tempHotelId = Hotel.HotelId(id: hotelId)
        let request = Hotel.SocialRequest(Social: tempHotelId)
        
        APIService.sharedInstance.handleGetHotelSocial(request) { (result: Hotel.ResultHotelSocial) in
            
            switch result {
            case .failure(_):
                self.fetchTempData()
            case .success(let response):
                if let socialMedias = response.result {
                    self.setSocialMedias(socialMedias)
                }
            }
            
        }
        
    }
}

extension SocialMediaController {
    
    fileprivate func setSocialMedias(_ socialMedias: [Hotel.Social]) {
        
        for socialMedia in socialMedias {
            
            var title: String?
            let tempSocialMedia = socialMedia.Social
            let link = tempSocialMedia?.link
            
            if currentLanguage() == DisplayName.england.rawValue {
                title = tempSocialMedia?.title
            } else if currentLanguage() == DisplayName.france.rawValue {
                title = tempSocialMedia?.title_french
            } else if currentLanguage() == DisplayName.germany.rawValue {
                title = tempSocialMedia?.title_german
            } else if currentLanguage() == DisplayName.italy.rawValue {
                title = tempSocialMedia?.title_italian
            } else {
                title = tempSocialMedia?.title_russian
            }
            
            let social = SocialMedia(title: title, link: link)
            self.socialMedias.append(social)
            
        }
        
        let height = tableViewCellHeight * CGFloat(self.socialMedias.count)
        
        DispatchQueue.main.async {
            
            self.tableViewHeightConstraint?.constant = height
            self.tableView.reloadData()
        }
        
    }
    
    fileprivate func fetchTempData() {
        
        let social1 = SocialMedia(title: "Facebook", link: "https://www.facebook.com/")
        let social2 = SocialMedia(title: "Twitter", link: "http://www.annabellebeachresort.gr/all-inclusive-hotel-crete#modal")
        let social3 = SocialMedia(title: "Instagram", link: "https://www.instagram.com/")
        let social4 = SocialMedia(title: "Youtube", link: "https://www.youtube.com/watch?v=FWbpb6TRIOM")
        let social5 = SocialMedia(title: "booking.com", link: "https://www.booking.com/hotel/gr/annabelle-beach-resort.en-gb.html?")
        
        self.socialMedias.append(social1)
        self.socialMedias.append(social2)
        self.socialMedias.append(social3)
        self.socialMedias.append(social4)
        self.socialMedias.append(social5)
        let height = tableViewCellHeight * CGFloat(socialMedias.count)
        tableViewHeightConstraint?.constant = height
        self.tableView.reloadData()
    }
}

extension SocialMediaController {
    
    func handleSocialButton(link: String) {
        
        guard let url = GlobalFunction.getUrlFromString(link) else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
}

extension SocialMediaController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return socialMedias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SocialMediaCell
        
        cell.socialMediaController = self
        cell.socialMedia = socialMedias[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableViewCellHeight
    }
    
}

extension SocialMediaController {
    
    @objc fileprivate func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
}

extension SocialMediaController {
    
    fileprivate func setupViews() {
        
        setupBackground()
        setupNavBar()
        setupTableView()
    }
    
    private func setupTableView() {
        
        tableView.register(SocialMediaCell.self, forCellReuseIdentifier: cellId)
        
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
