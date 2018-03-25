//
//  AboutCreteDescriptionController.swift
//  HotelCrete
//
//  Created by John Nik on 24/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class AboutCreteDescriptionController: UIViewController {
    
    var aboutCrete: Crete.AboutCrete?
    
    let detailTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textAlignment = .center
        textView.isEditable = false
        textView.textColor = .darkGray
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        setupAboutCrete()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        detailTextView.isScrollEnabled = true
    }
    
    func setupAboutCrete() {
        guard let aboutCrete = aboutCrete else { return }
        navigationItem.title = getLocalizedString(from: aboutCrete, type: .title)
        
        detailTextView.text = getLocalizedString(from: aboutCrete, type: .description)?.htmlToString
        detailTextView.isScrollEnabled = false
    }
    
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(detailTextView)
        detailTextView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}

extension AboutCreteDescriptionController {
    func getLocalizedString(from detail: Crete.AboutCrete, type: StringType) -> String? {
        var string: String?
        
        if currentLanguage() == DisplayName.england.rawValue {
            if type == .title {
                string = detail.title
            } else {
                string = detail.description
            }
            
        } else if currentLanguage() == DisplayName.france.rawValue {
            if type == .title {
                string = detail.title_french
            } else {
                string = detail.description_french
            }
            
        } else if currentLanguage() == DisplayName.germany.rawValue {
            if type == .title {
                string = detail.title_german
            } else {
                string = detail.description_german
            }
            
        } else if currentLanguage() == DisplayName.italy.rawValue {
            if type == .title {
                string = detail.title_italian
            } else {
                string = detail.description_italian
            }
            
        } else {
            if type == .title {
                string = detail.title_russian
            } else {
                string = detail.description_russian
            }
            
        }
        
        return string
    }
}
