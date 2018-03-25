//
//  GreekWordsController.swift
//  HotelCrete
//
//  Created by John Nik on 27/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import SVProgressHUD

class GreekWordsController: UIViewController {
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    let greekWordDescription = "Greek is not an easy language, but it is a beautiful one and even a brief acquaintance will give you some idea of the debt western European languages owe to it. To beginn with it, the best thing is simply to say what you know the way you know it and never mind the niceties. If you worry about mistakes, you will never say anything.".localized()
    
    var greekWordLists: [GreekWord.GreekWordList] = []
    
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
        fethcGreekWords()
    }
}

extension GreekWordsController {
    
    fileprivate func fethcGreekWords() {
        
        
        guard ReachabilityManager.shared.internetIsUp else {
            
            self.showPMAlertOkay(title: "Internet Error", message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        
        
        APIService.sharedInstance.handleGetGreekWords { (result: GreekWord.ResultGreekWord) in
            
            switch result {
            case .failure(_):
                self.showErrorMessage(title: "Server Error", message: AlertMessages.somethingWentWrong.rawValue)
            case .success(let response):
                if let greekWordLists = response.result {
                    
                    self.greekWordLists = greekWordLists
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            
        }
        
    }
    
}

extension GreekWordsController {
    
    func showErrorMessage(title: String, message: String) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.showPMAlertOkay(title: title, message: message)
        }
    }
}

extension GreekWordsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return greekWordLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! GreekWordCell
    
            
        cell.greekWordList = greekWordLists[indexPath.row]
        cell.setNeedsDisplay()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let wordsLists = greekWordLists[indexPath.row].GreekDescription
        
        var height: CGFloat = 50
        if wordsLists.count > 0 {
            height = 170
        }
        for wordList in wordsLists {
            
            let words = [wordList.english, wordList.greek, wordList.pronunciation]
            
            if var maxWord = words.max(by: {$1.count > $0.count}) {
                
                var fontSize: CGFloat = 15
                
                if GlobalFunction.isContainedString("</", of: maxWord) {
                    maxWord = maxWord.htmlToString.trailingNewLinesTrimmed
                    fontSize = 16
                }
                
                let estimateHeight = GlobalFunction.estimateFrameForText(text: maxWord, width: MATRIX_NUMBERS_COLUMN_WIDTH, font: fontSize).height + 20
                
                height += max(MATRIX_ROW_HEIGHT, estimateHeight)
                
            }
        }
        
        return height
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let estimatedSize = GlobalFunction.estimateFrameForText(text: greekWordDescription, width: view.frame.width - 20, font: CGFloat(17))
        
        let height = max(50, estimatedSize.height + 80)
        
        return height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! GreekWordHeaderCell
        
        let greekWordAbout = GreekWord.GreekWordAbout(title: "Greek Words".localized(), description: greekWordDescription)
        
        header.greekWordAbout = greekWordAbout
        return header
    }
}

extension GreekWordsController {
    
    fileprivate func setupViews() {
        
        setupBackground()
        setupNavBar()
        setupTableView()
    }
    
    private func setupTableView() {
        
        tableView.register(GreekWordCell.self, forCellReuseIdentifier: cellId)
        tableView.register(GreekWordHeaderCell.self, forHeaderFooterViewReuseIdentifier: headerId)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    private func setupNavBar() {
        
        navigationItem.title = "Greek Words".localized()
    }
    
    private func setupBackground() {
        view.backgroundColor = .white
    }
}


