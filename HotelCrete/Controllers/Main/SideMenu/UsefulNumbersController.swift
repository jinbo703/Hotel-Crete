//
//  UsefulNumbersController.swift
//  HotelCrete
//
//  Created by John Nik on 28/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import SVProgressHUD

class UsefulNumbersController: UIViewController {
    
    let cellId = "cellId"
    
    var groupedNumbers: [UsefulNumbers.UsefulNumbers] = []
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        fethcUsefulNumbers()
    }
}

extension UsefulNumbersController {
    
    fileprivate func fethcUsefulNumbers() {
        
        
        guard ReachabilityManager.shared.internetIsUp else {
            
            self.showPMAlertOkay(title: "Internet Error", message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        
        APIService.sharedInstance.handleGetUsefulNumbers { (result: UsefulNumbers.ResultUsefulNumbers) in
            
            switch result {
            case .failure(_):
                self.showErrorMessage(title: "Server Error", message: AlertMessages.somethingWentWrong.rawValue)
            case .success(let response):
                if let groupedNumbers = response.result {
                    
                    self.setupGroupedNumbers(groupedNumbers)
                    
                }
            }
            
        }
    }
    
    func setupGroupedNumbers(_ groupedNumbers: [UsefulNumbers.UsefulNumbers]) {
        
        for groupedNumber in groupedNumbers {
            
            var title: String?
            var description: String?
            
            let tempUsefulNumber = groupedNumber.UsefulNumber
            
            
            if currentLanguage() == DisplayName.england.rawValue {
                title = tempUsefulNumber?.title
                description = tempUsefulNumber?.description
            } else if currentLanguage() == DisplayName.france.rawValue {
                title = tempUsefulNumber?.title_french
                description = tempUsefulNumber?.description_french
            } else if currentLanguage() == DisplayName.germany.rawValue {
                title = tempUsefulNumber?.title_german
                description = tempUsefulNumber?.description_german
            } else if currentLanguage() == DisplayName.italy.rawValue {
                title = tempUsefulNumber?.title_italian
                description = tempUsefulNumber?.description_italian
            } else {
                title = tempUsefulNumber?.title_russian
                description = tempUsefulNumber?.description_russian
            }

            var newUsefulNumberDetails: [UsefulNumbers.UsefulNumberDetail] = []
            
            if let tempUsefulDetails = groupedNumber.UsefulData {
                for tempUsefulDetail in tempUsefulDetails {
                    
                    var subTitle: String?
                    
                    if currentLanguage() == DisplayName.england.rawValue {
                        subTitle = tempUsefulDetail.title
                    } else if currentLanguage() == DisplayName.france.rawValue {
                        subTitle = tempUsefulDetail.title_french
                    } else if currentLanguage() == DisplayName.germany.rawValue {
                        subTitle = tempUsefulDetail.title_german
                    } else if currentLanguage() == DisplayName.italy.rawValue {
                        subTitle = tempUsefulDetail.title_italian
                    } else {
                        subTitle = tempUsefulDetail.title_russian
                    }
                    
                    let newUsefulNumberDetail = UsefulNumbers.UsefulNumberDetail(id: tempUsefulDetail.id, usefulnumberid: tempUsefulDetail.usefulnumberid, title: subTitle, number: tempUsefulDetail.number, created_date: tempUsefulDetail.created_date, title_french: nil, title_german: nil, title_italian: nil, title_russian: nil)
                    
                    newUsefulNumberDetails.append(newUsefulNumberDetail)
                }
            }
            
            
            
            let newUsefulNumber = UsefulNumbers.UsefulNumber(id: tempUsefulNumber?.id, title: title, title_greek: nil, description: description, description_greek: nil, created_date: tempUsefulNumber?.created_date, title_french: nil, description_french: nil, title_german: nil, description_german: nil, title_italian: nil, description_italian: nil, title_russian: nil, description_russian: nil)
            
            
            let newGroupedNumber = UsefulNumbers.UsefulNumbers(UsefulNumber: newUsefulNumber, UsefulData: newUsefulNumberDetails)
            
            self.groupedNumbers.append(newGroupedNumber)
            
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

extension UsefulNumbersController {
    
    func showErrorMessage(title: String, message: String) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.showPMAlertOkay(title: title, message: message)
        }
    }
}

extension UsefulNumbersController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedNumbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! GeneralNumbersCell
        
        
        cell.usefulNumbers = groupedNumbers[indexPath.row]
        cell.setNeedsDisplay()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
        var height: CGFloat = 70
        
        if let numbers = groupedNumbers[indexPath.row].UsefulData {
            for numberDetail in numbers {
                
                if let title = numberDetail.title, let number = numberDetail.number {
                    let words = [title, number]
                    
                    if var maxWord = words.max(by: {$1.count > $0.count}) {
                        
                        var fontSize: CGFloat = 15
                        
                        if GlobalFunction.isContainedString("</", of: maxWord) {
                            maxWord = maxWord.htmlToString
                            fontSize = 15
                        }
                        
                        let estimateHeight = GlobalFunction.estimateFrameForText(text: maxWord, width: MATRIX_NUMBERS_COLUMN_WIDTH, font: fontSize).height + 20
                        
                        height += max(MATRIX_ROW_HEIGHT, estimateHeight)
                        
                    }
                }
            }
        }
        
        if let description = groupedNumbers[indexPath.row].UsefulNumber?.description, description.count > 0 {
            
            let estimateHeight = GlobalFunction.estimateFrameForText(text: description.htmlToString, width: MATRIX_WIDTH, font: CGFloat(15)).height + 40
            
            height += max(MATRIX_ROW_HEIGHT, estimateHeight)
        }
        
        
        return height
        
    }
}

extension UsefulNumbersController {
    
    fileprivate func setupViews() {
        
        setupBackground()
        setupNavBar()
        setupTableView()
    }
    
    private func setupTableView() {
        
        tableView.register(GeneralNumbersCell.self, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    private func setupNavBar() {
        
        navigationItem.title = "Useful Numbers"
    }
    
    private func setupBackground() {
        view.backgroundColor = .white
    }
}



