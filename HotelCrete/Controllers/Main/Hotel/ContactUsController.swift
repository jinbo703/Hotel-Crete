//
//  ContactUsController.swift
//  HotelCrete
//
//  Created by John Nik on 18/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import MessageUI

class ContactUsController: UIViewController {
    
    let cellId = "cellId"
    
    var contacts = [Contact]()
    
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
        tv.separatorStyle = .singleLine
        tv.separatorColor = .darkGray
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        fetchContacts()
    }
    
    func fetchContacts() {
        
        let contact1 = Contact(title: "Telephone Number", contactDetail: "+357 22007731", type: .telephone)
        let contact2 = Contact(title: "Fax Number", contactDetail: "+44 3300109332", type: .fax)
        let contact3 = Contact(title: "Email Address", contactDetail: "info@annabellebeach.gr", type: .email)
        let contact4 = Contact(title: "Web site", contactDetail: "www.annabellebeach.gr", type: .website)
        
        contacts.append(contact1)
        contacts.append(contact2)
        contacts.append(contact3)
        contacts.append(contact4)
        
        tableView.reloadData()
    }
}

extension ContactUsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactUsCell
        cell.contact = contacts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = contacts[indexPath.row]
        self.handleContact(contact)
    }
    
}

extension ContactUsController {
    
    fileprivate func handleContact(_ contact: Contact) {
        
        guard let type = contact.type, let link = contact.contactDetail else { return }
        let application = UIApplication.shared
        if type == .website {
            guard let url = GlobalFunction.getUrlFromString("https://" + link) else { return }
            
            application.open(url, options: [:], completionHandler: nil)
        } else if type == .email {
            
            handleSendingEmail()
            
        } else if type == .telephone || type == .fax {
            
            if let phoneCallURL = URL(string: "tel://\(link.trimmingCharacters(in: .whitespaces))") {
                
                if (application.canOpenURL(phoneCallURL)) {
                
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
            } else {
                self.showPMAlertOkay(title: "Error", message: "Sorry, it's invalid phone number")
            }
        }
        
    }
}

extension ContactUsController: MFMailComposeViewControllerDelegate {
    fileprivate func handleSendingEmail() {
        
        let mailComposeController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["info@annabellebeach.gr"])
        mailComposerVC.setSubject("Hotel & Crete")
        mailComposerVC.setMessageBody("Please tell us your problem!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        self.showPMAlertOkay(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}


extension ContactUsController {
    
    @objc fileprivate func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
}

extension ContactUsController {
    
    fileprivate func setupViews() {
        
        setupBackground()
        setupTableView()
        setupNavBar()
    }
    
    private func setupBackground() {
        view.backgroundColor = .white
        
//        view.addSubview(backgroundImageView)
//        backgroundImageView.anchorToTop(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
    }
    
    private func setupNavBar() {
        
        navigationItem.title = "Contact Us"
        
        let image = UIImage(named: AssetName.back.rawValue)
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleDismiss))
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupTableView() {
        
        tableView.register(ContactUsCell.self, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        tableView.anchorToTop(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
    }
}
