//
//  MessagesController.swift
//  HotelCrete
//
//  Created by John Nik on 26/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import SVProgressHUD

class MessagesController: UICollectionViewController {
    
    let cellId = "cellId"
    
    var messages: [Message.Chat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        fetchMessages()
    }
    
    fileprivate func fetchMessages() {
        
        guard ReachabilityManager.shared.internetIsUp else {
            
            self.showPMAlertOkay(title: "Internet Error", message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        
        let userDefaults = UserDefaults.standard
        guard let userId = userDefaults.getUserId() else { return }
        let hotelCode = userDefaults.getHotelCode()
        
        
        let chatInfo = Message.ChatInfo(uid: userId, code: hotelCode, name: nil, msg: nil, image: nil, created_date: nil)
        let request = Message.RequestChat(chat: chatInfo)
        
        APIService.sharedInstance.handleGetMessages(request) { (result: Message.ResultChat) in
            
            switch result {
            case .failure(_):
                self.showErrorMessage(title: "Server Error", message: AlertMessages.somethingWentWrong.rawValue)
            case .success(let response):
                if let messages = response.data {
                    
                    self.messages = messages
                    
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                    
                }
            }
            
        }
        
    }
}

extension MessagesController {
    
    func showErrorMessage(title: String, message: String) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.showPMAlertOkay(title: title, message: message)
        }
    }
}

extension MessagesController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCell
        cell.message = messages[indexPath.item].Chat
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = MessageCell(frame: frame)
        dummyCell.message = messages[indexPath.item].Chat
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width - 40, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(40, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension MessagesController {
    
    fileprivate func setupViews() {
        setupNavBar()
        setupCollectionView()
    }
    
    private func setupNavBar() {
        
        navigationItem.title = "Messages".localized()
        
        view.backgroundColor = .white
    }
    
    private func setupCollectionView() {
        collectionView?.backgroundColor = .white
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.isScrollEnabled = true
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
}


